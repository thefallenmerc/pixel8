import Fastify, { type FastifyReply, type FastifyRequest } from "fastify";
import cors from "@fastify/cors";
import rateLimit from "@fastify/rate-limit";
import websocket from "@fastify/websocket";
import { Pool } from "pg";
import PgBoss from "pg-boss";
import { randomUUID, createHash } from "node:crypto";
import { isDeepStrictEqual } from "node:util";
import { z, ZodError } from "zod";
import { prisma } from "@pixel8/database";
import { auth } from "./auth.js";
import { config } from "./config.js";
import {
  digest,
  encrypt,
  decrypt,
  newPairingCode,
  randomSecret,
} from "./security.js";
import {
  startMultipart,
  signPart,
  completeMultipart,
  abortMultipart,
  headObject,
  signedObject,
  s3,
} from "./storage.js";
import { DeleteObjectCommand } from "@aws-sdk/client-s3";
import {
  createAppSchema,
  patchAppSchema,
  createCampaignSchema,
  updateCampaignSchema,
  uploadCreateSchema,
  screenPatchSchema,
  pairingRequestSchema,
  capabilitiesSchema,
  telemetrySampleSchema,
  playbackAckSchema,
} from "@pixel8/contracts";

const app = Fastify({ logger: true, bodyLimit: 1024 * 1024 });
const boss = new PgBoss({ connectionString: config.databaseUrl });
boss.on("error", (error) => app.log.error(error, "pg-boss runtime error"));
await app.register(cors, {
  origin: (process.env.TRUSTED_ORIGINS ?? "http://localhost:3000")
    .split(",")
    .map((x) => x.trim()),
  credentials: true,
  methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  exposedHeaders: ["set-auth-token"],
});
await app.register(rateLimit, { max: 600, timeWindow: "1 minute" });
await app.register(websocket);
await boss.start();
await boss.createQueue("process-asset");
await boss.createQueue("process-campaign");
const pg = new Pool({ connectionString: config.databaseUrl });
const sockets = new Map<string, Set<any>>();
function fail(
  status: number,
  code: string,
  message: string,
  details?: unknown,
): never {
  const e: any = new Error(message);
  e.statusCode = status;
  e.code = code;
  if (details !== undefined) e.details = details;
  throw e;
}
app.setErrorHandler((error, req, reply) => {
  if (error instanceof ZodError)
    return reply.code(422).send({
      error: {
        code: "VALIDATION_ERROR",
        message: "Request validation failed",
        details: error.flatten(),
      },
    });
  const e = error as any;
  if (e.code === "P2002")
    return reply.code(409).send({
      error: {
        code: "CONFLICT",
        message: "A record with these values already exists",
      },
    });
  req.log.error(error);
  return reply.code(e.statusCode ?? 500).send({
    error: {
      code: e.code ?? "INTERNAL_ERROR",
      message: e.statusCode ? e.message : "An internal error occurred",
      ...(e.details ? { details: e.details } : {}),
    },
  });
});
const userFor = async (req: FastifyRequest) => {
  const session = await auth.api.getSession({ headers: req.headers as any });
  if (!session?.user) fail(401, "UNAUTHENTICATED", "Sign in is required");
  return session.user;
};
const ownerApp = async (userId: string, id: string) => {
  const row = await prisma.app.findFirst({
    where: { id, ownerId: userId, deletedAt: null },
  });
  if (!row) fail(404, "NOT_FOUND", "App not found");
  return row;
};
const ownerScreen = async (userId: string, id: string) => {
  const row = await prisma.screen.findFirst({ where: { id, ownerId: userId } });
  if (!row) fail(404, "NOT_FOUND", "Screen not found");
  return row;
};
const asJson = (x: any) => x as any;
const appDto = (a: any) => ({
  id: a.id,
  name: a.name,
  description: a.description,
  createdAt: a.createdAt.toISOString(),
});
const assetDto = (a: any) => ({
  id: a.id,
  appId: a.appId,
  name: a.name,
  mimeType: a.mimeType,
  sizeBytes: Number(a.sizeBytes),
  status: a.status,
  ...(a.thumbnailKey
    ? { thumbnailUrl: `${config.publicUrl}/v1/assets/${a.id}/thumbnail` }
    : {}),
  ...(a.error ? { error: a.error } : {}),
});
const campaignDto = (c: any, r: any) => ({
  id: c.id,
  appId: c.appId,
  name: c.name,
  description: c.description,
  revision: c.revision,
  currentRevision: c.currentRevision,
  status: c.status,
  items: (r?.items ?? []).map((i: any) => ({
    assetId: i.assetId,
    durationSeconds: i.durationSeconds,
    fit: i.fit,
  })),
  ...(c.error ? { error: c.error } : {}),
});
const screenDto = (s: any) => ({
  id: s.id,
  name: s.name,
  campaignId: s.campaignId,
  orientation: s.orientation,
  muted: s.muted,
  volume: s.volume,
  desiredVersion: s.desiredVersion,
  playingVersion: s.playingVersion,
  status:
    s.lastSeenAt && Date.now() - s.lastSeenAt.getTime() > 90_000
      ? "offline"
      : s.status,
  ...(s.lastSeenAt ? { lastSeenAt: s.lastSeenAt.toISOString() } : {}),
  ...(s.error ? { error: s.error } : {}),
  ...(s.capabilities ? { capabilities: s.capabilities } : {}),
  ...(s.latestTelemetry ? { latestTelemetry: s.latestTelemetry } : {}),
});
const screenDtoWithLatestTelemetry = async (screen: any) => {
  const sample = await prisma.telemetry.findFirst({
    where: { screenId: screen.id },
    orderBy: { sampledAt: "desc" },
    select: { payload: true },
  });
  return screenDto({ ...screen, latestTelemetry: sample?.payload });
};
const screenDtosWithLatestTelemetry = async (screens: any[]) => {
  if (!screens.length) return [];
  const rows = await prisma.$queryRaw<
    { screenId: string; payload: unknown }[]
  >`SELECT DISTINCT ON ("screenId") "screenId", "payload" FROM "Telemetry" WHERE "screenId" = ANY(${screens.map((s) => s.id)}::uuid[]) ORDER BY "screenId", "sampledAt" DESC`;
  const latest = new Map(rows.map((row) => [row.screenId, row.payload]));
  return screens.map((screen) =>
    screenDto({ ...screen, latestTelemetry: latest.get(screen.id) }),
  );
};
const notifyScreen = async (id: string, version: number) => {
  await pg.query("SELECT pg_notify('pixel8_screen', $1)", [
    JSON.stringify({ screenId: id, version }),
  ]);
};
const enqueue = async (tx: any, type: string, payload: object) =>
  tx.job.create({ data: { type, payload: asJson(payload) } });
async function buildManifest(tx: any, screen: any) {
  if (!screen.campaignId)
    return {
      schemaVersion: 1,
      screenId: screen.id,
      version: screen.desiredVersion,
      profile: "720p30-v1",
      orientation: screen.orientation,
      muted: screen.muted,
      volume: screen.volume,
      items: [],
    };
  const campaign = await tx.campaign.findFirst({
    where: { id: screen.campaignId, currentRevision: { not: null } },
  });
  if (!campaign?.currentRevision) return null;
  const caps = screen.capabilities as any;
  const profile = caps?.supports1080p === true ? "1080p30-v1" : "720p30-v1";
  const list = await tx.campaignItem.findMany({
    where: {
      revision: { campaignId: campaign.id, revision: campaign.currentRevision },
    },
    include: {
      variants: {
        where: { profile, orientation: screen.orientation },
        include: { rendition: true },
      },
    },
    orderBy: { ordinal: "asc" },
  });
  if (list.some((item: any) => item.variants.length === 0)) return null;
  return {
    schemaVersion: 1,
    screenId: screen.id,
    version: screen.desiredVersion,
    profile,
    orientation: screen.orientation,
    muted: screen.muted,
    volume: screen.volume,
    items: list.map((item: any) => {
      const r = item.variants[0].rendition;
      return {
        id: item.id,
        assetId: item.assetId,
        renditionId: r.id,
        sha256: r.sha256,
        sizeBytes: Number(r.sizeBytes),
        durationMs: Math.round(r.durationSeconds * 1000),
      };
    }),
  };
}
async function saveManifest(tx: any, screen: any) {
  const body = await buildManifest(tx, screen);
  if (body)
    await tx.manifestRecord.create({
      data: {
        screenId: screen.id,
        version: screen.desiredVersion,
        body: asJson(body),
      },
    });
}
const requireDevice = async (req: FastifyRequest) => {
  const value = req.headers.authorization;
  if (!value?.startsWith("Bearer "))
    fail(401, "UNAUTHENTICATED", "Device bearer token is required");
  const token = value.slice(7);
  const screen = await prisma.screen.findFirst({
    where: { deviceTokenHash: digest(token) },
  });
  if (!screen) fail(401, "UNAUTHENTICATED", "Invalid device token");
  if (screen.deviceTokenCiphertext) {
    await prisma.$transaction([
      prisma.screen.update({
        where: { id: screen.id },
        data: { lastSeenAt: new Date(), deviceTokenCiphertext: null },
      }),
      prisma.pairing.updateMany({
        where: { screenId: screen.id },
        data: { encryptedDeviceToken: null },
      }),
    ]);
  } else
    await prisma.screen.update({
      where: { id: screen.id },
      data: { lastSeenAt: new Date() },
    });
  return screen;
};
app.all("/api/auth/*", async (req, reply) => {
  const response: Response = await auth.handler(
    new Request(`${config.publicUrl}${req.url}`, {
      method: req.method,
      headers: req.headers as any,
      body: ["GET", "HEAD"].includes(req.method)
        ? undefined
        : JSON.stringify(req.body),
    }),
  );
  reply.code(response.status);
  response.headers.forEach((v: string, k: string) => reply.header(k, v));
  return reply.send(Buffer.from(await response.arrayBuffer()));
});
app.get("/health", async () => ({ ok: true }));
app.get("/ready", async () => {
  await prisma.$queryRaw`SELECT 1`;
  return { ok: true, database: "ready" };
});

app.get("/v1/apps", async (req) => {
  const u = await userFor(req);
  return {
    items: (
      await prisma.app.findMany({
        where: { ownerId: u.id, deletedAt: null },
        orderBy: { createdAt: "desc" },
      })
    ).map(appDto),
  };
});
app.post("/v1/apps", async (req) => {
  const u = await userFor(req);
  const b = createAppSchema.parse(req.body);
  return appDto(
    await prisma.app.create({
      data: { ownerId: u.id, name: b.name, description: b.description ?? null },
    }),
  );
});
app.get("/v1/apps/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  return appDto(await ownerApp(u.id, id));
});
app.patch("/v1/apps/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  await ownerApp(u.id, id);
  const b = patchAppSchema.parse(req.body);
  return appDto(await prisma.app.update({ where: { id }, data: b }));
});
app.delete("/v1/apps/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  await prisma.$transaction(async (tx) => {
    const locked = await tx.$queryRaw<Array<{ id: string }>>`
      SELECT "id" FROM "App" WHERE "id" = ${id}::uuid AND "ownerId" = ${u.id} AND "deletedAt" IS NULL FOR UPDATE
    `;
    if (!locked.length) fail(404, "NOT_FOUND", "App not found");
    const assigned = await tx.screen.count({
      where: { ownerId: u.id, campaign: { appId: id } },
    });
    if (assigned) fail(409, "REFERENCED", "App has assigned screens");
    await tx.app.update({ where: { id }, data: { deletedAt: new Date() } });
  });
  return { ok: true };
});
app.get("/v1/apps/:appId/assets", async (req) => {
  const u = await userFor(req);
  const { appId } = req.params as any;
  await ownerApp(u.id, appId);
  return {
    items: (
      await prisma.asset.findMany({
        where: { appId, deletedAt: null },
        orderBy: { createdAt: "desc" },
      })
    ).map(assetDto),
  };
});
app.delete("/v1/assets/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  await prisma.$transaction(async (tx) => {
    const locked = await tx.$queryRaw<Array<{ id: string }>>`
      SELECT "id" FROM "Asset" WHERE "id" = ${id}::uuid FOR UPDATE
    `;
    if (!locked.length) fail(404, "NOT_FOUND", "Asset not found");
    const a = await tx.asset.findFirst({
      where: { id, deletedAt: null, app: { ownerId: u.id, deletedAt: null } },
    });
    if (!a) fail(404, "NOT_FOUND", "Asset not found");
    const references = await tx.campaignItem.count({ where: { assetId: id } });
    if (references)
      fail(409, "REFERENCED", "Asset is referenced by a campaign");
    await tx.asset.update({ where: { id }, data: { deletedAt: new Date() } });
  });
  return { ok: true };
});

app.get("/v1/apps/:appId/campaigns", async (req) => {
  const u = await userFor(req);
  const { appId } = req.params as any;
  await ownerApp(u.id, appId);
  const rows = await prisma.campaign.findMany({
    where: { appId },
    include: {
      revisions: {
        orderBy: { revision: "desc" },
        take: 1,
        include: { items: { orderBy: { ordinal: "asc" } } },
      },
    },
    orderBy: { createdAt: "desc" },
  });
  return { items: rows.map((c) => campaignDto(c, c.revisions[0])) };
});
async function validateItems(tx: any, appId: string, items: any[]) {
  const ids = [...new Set(items.map((i) => i.assetId))];
  for (const assetId of ids)
    await tx.$queryRaw`SELECT "id" FROM "Asset" WHERE "id" = ${assetId}::uuid FOR SHARE`;
  const assets = await tx.asset.findMany({
    where: {
      id: { in: ids },
      appId,
      status: "ready",
      deletedAt: null,
      app: { deletedAt: null },
    },
  });
  if (assets.length !== ids.length)
    fail(
      422,
      "INVALID_ASSET",
      "Every campaign asset must be ready, active, and belong to the same app",
    );
}
app.post("/v1/apps/:appId/campaigns", async (req) => {
  const u = await userFor(req);
  const { appId } = req.params as any;
  await ownerApp(u.id, appId);
  const b = createCampaignSchema.parse(req.body);
  const c = await prisma.$transaction(async (tx) => {
    await validateItems(tx, appId, b.items);
    const campaign = await tx.campaign.create({
      data: {
        appId,
        name: b.name,
        description: b.description ?? null,
        revision: 1,
        status: "preparing",
        revisions: {
          create: {
            revision: 1,
            status: "preparing",
            items: { create: b.items.map((i, ordinal) => ({ ...i, ordinal })) },
          },
        },
      },
    });
    await enqueue(tx, "process-campaign", {
      campaignId: campaign.id,
      revision: 1,
    });
    return campaign;
  });
  return campaignDto(c, { items: b.items });
});
app.get("/v1/campaigns/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const c = await prisma.campaign.findFirst({
    where: { id, app: { ownerId: u.id, deletedAt: null } },
    include: {
      revisions: {
        orderBy: { revision: "desc" },
        take: 1,
        include: { items: { orderBy: { ordinal: "asc" } } },
      },
    },
  });
  if (!c) fail(404, "NOT_FOUND", "Campaign not found");
  return campaignDto(c, c.revisions[0]);
});
app.put("/v1/campaigns/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const b = updateCampaignSchema.parse(req.body);
  const c = await prisma.$transaction(async (tx) => {
    const current = await tx.campaign.findFirst({
      where: { id, app: { ownerId: u.id, deletedAt: null } },
    });
    if (!current) fail(404, "NOT_FOUND", "Campaign not found");
    const update = await tx.campaign.updateMany({
      where: { id, revision: b.expectedRevision },
      data: {
        name: b.name,
        description: b.description ?? null,
        revision: { increment: 1 },
        status: "preparing",
        error: null,
      },
    });
    if (!update.count)
      fail(409, "REVISION_CONFLICT", "Campaign revision has changed");
    const revision = b.expectedRevision + 1;
    await validateItems(tx, current.appId, b.items);
    await tx.campaignRevision.create({
      data: {
        campaignId: id,
        revision,
        status: "preparing",
        items: { create: b.items.map((i, ordinal) => ({ ...i, ordinal })) },
      },
    });
    await enqueue(tx, "process-campaign", { campaignId: id, revision });
    return tx.campaign.findUnique({ where: { id } });
  });
  return campaignDto(c, { items: b.items });
});
app.delete("/v1/campaigns/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const b = z
    .object({ unassignScreens: z.literal(true).optional() })
    .parse(req.body ?? {});
  const changed = await prisma.$transaction(async (tx) => {
    await tx.$queryRaw`SELECT "id" FROM "Campaign" WHERE "id" = ${id}::uuid FOR UPDATE`;
    const c = await tx.campaign.findFirst({
      where: { id, app: { ownerId: u.id } },
    });
    if (!c) fail(404, "NOT_FOUND", "Campaign not found");
    const screens = await tx.screen.findMany({
      where: { ownerId: u.id, campaignId: id },
    });
    if (screens.length && !b.unassignScreens)
      fail(409, "ASSIGNED", "Campaign is assigned to screens");
    const touched = [];
    for (const s of screens) {
      const unassigned = await tx.screen.updateMany({
        where: {
          id: s.id,
          ownerId: u.id,
          campaignId: id,
          desiredVersion: s.desiredVersion,
        },
        data: {
          campaignId: null,
          desiredVersion: { increment: 1 },
          status: "ready",
        },
      });
      if (!unassigned.count) {
        const latest = await tx.screen.findUnique({ where: { id: s.id } });
        if (latest?.campaignId === id)
          fail(409, "VERSION_CONFLICT", "Screen desired version has changed");
        continue;
      }
      const n = await tx.screen.findUnique({ where: { id: s.id } });
      if (!n) continue;
      await tx.desiredState.create({
        data: {
          screenId: n.id,
          version: n.desiredVersion,
          campaignId: null,
          campaignRevision: null,
          orientation: n.orientation,
          muted: n.muted,
          volume: n.volume,
        },
      });
      await saveManifest(tx, n);
      await tx.$queryRaw`SELECT pg_notify('pixel8_screen', ${JSON.stringify({ screenId: n.id, version: n.desiredVersion })})::text AS notified`;
      touched.push(n.id);
    }
    await tx.campaign.delete({ where: { id } });
    return touched;
  });
  return { ok: true, unassignedScreenIds: changed };
});

app.post("/v1/apps/:appId/uploads", async (req) => {
  const u = await userFor(req);
  const { appId } = req.params as any;
  await ownerApp(u.id, appId);
  const b = uploadCreateSchema.parse(req.body);
  if (b.sizeBytes > config.maxUploadBytes)
    fail(
      413,
      "UPLOAD_TOO_LARGE",
      `Upload exceeds the configured ${config.maxUploadBytes} byte limit`,
    );
  if (
    ![
      "image/jpeg",
      "image/png",
      "image/webp",
      "image/heic",
      "image/heif",
      "video/mp4",
      "video/quicktime",
      "video/webm",
      "video/x-matroska",
    ].includes(b.mimeType.toLowerCase())
  )
    fail(
      422,
      "UNSUPPORTED_MEDIA",
      "Supported media are JPEG, PNG, WebP, HEIC, MP4, QuickTime, WebM, and Matroska",
    );
  const id = randomUUID(),
    key = `source/${appId}/${id}`;
  const multipartId = await startMultipart(key, b.mimeType);
  try {
    const a = await prisma.asset.create({
      data: {
        id,
        appId,
        name: b.name,
        mimeType: b.mimeType,
        sizeBytes: BigInt(b.sizeBytes),
        status: "uploading",
        sourceKey: key,
        upload: {
          create: {
            objectKey: key,
            multipartId,
            expiresAt: new Date(Date.now() + 24 * 3600_000),
          },
        },
      },
    });
    return { asset: assetDto(a), uploadId: id, partSizeBytes: 8 * 1024 * 1024 };
  } catch (e) {
    await abortMultipart(key, multipartId);
    throw e;
  }
});
app.post("/v1/uploads/:uploadId/parts", async (req) => {
  const u = await userFor(req);
  const { uploadId } = req.params as any;
  const b = z
    .object({
      partNumbers: z
        .array(z.number().int().min(1).max(10000))
        .min(1)
        .max(10000),
    })
    .parse(req.body);
  const up = await prisma.upload.findFirst({
    where: { assetId: uploadId, asset: { app: { ownerId: u.id } } },
    include: { asset: true },
  });
  if (!up || up.expiresAt < new Date())
    fail(404, "NOT_FOUND", "Upload not found");
  const maxParts = Math.ceil(Number(up.asset.sizeBytes) / (8 * 1024 * 1024));
  if (b.partNumbers.some((n) => n > maxParts))
    fail(422, "INVALID_PART", "Part number exceeds the declared upload size");
  const parts = await Promise.all(
    b.partNumbers.map(async (partNumber) => ({
      partNumber,
      url: await signPart(up.objectKey, up.multipartId, partNumber),
    })),
  );
  return { parts, expiresAt: new Date(Date.now() + 900_000).toISOString() };
});
app.post("/v1/uploads/:uploadId/complete", async (req) => {
  const u = await userFor(req);
  const { uploadId } = req.params as any;
  const b = z
    .object({
      parts: z
        .array(
          z.object({
            partNumber: z.number().int().positive(),
            etag: z.string().min(1),
          }),
        )
        .min(1),
    })
    .parse(req.body);
  const up = await prisma.upload.findFirst({
    where: { assetId: uploadId, asset: { app: { ownerId: u.id } } },
    include: { asset: true },
  });
  if (!up) {
    const completed = await prisma.asset.findFirst({
      where: { id: uploadId, app: { ownerId: u.id } },
    });
    if (completed && completed.status !== "uploading")
      return assetDto(completed);
    fail(404, "NOT_FOUND", "Upload not found");
  }
  if (up.expiresAt < new Date()) fail(404, "NOT_FOUND", "Upload not found");
  const maxParts = Math.ceil(Number(up.asset.sizeBytes) / (8 * 1024 * 1024));
  if (
    new Set(b.parts.map((x) => x.partNumber)).size !== b.parts.length ||
    b.parts.some((p, i) => p.partNumber !== i + 1) ||
    b.parts.length !== maxParts
  )
    fail(422, "INVALID_PARTS", "Parts must be complete, unique, and in order");
  let head: Awaited<ReturnType<typeof headObject>> | undefined;
  try {
    head = await headObject(up.objectKey);
  } catch {
    try {
      await completeMultipart(up.objectKey, up.multipartId, b.parts);
    } catch (completionError) {
      try {
        head = await headObject(up.objectKey);
      } catch {
        throw completionError;
      }
    }
    head ??= await headObject(up.objectKey);
  }
  if (Number(head.ContentLength) !== Number(up.asset.sizeBytes)) {
    await s3.send(
      new DeleteObjectCommand({ Bucket: config.bucket, Key: up.objectKey }),
    );
    fail(
      422,
      "SIZE_MISMATCH",
      "Uploaded object size does not match declaration",
    );
  }
  const updated = await prisma.$transaction(async (tx) => {
    await tx.$queryRaw`SELECT "id" FROM "Upload" WHERE "id" = ${up.id}::uuid FOR UPDATE`;
    const currentUpload = await tx.upload.findUnique({ where: { id: up.id } });
    if (!currentUpload) {
      const alreadyCompleted = await tx.asset.findFirst({
        where: { id: up.assetId, app: { ownerId: u.id } },
      });
      if (alreadyCompleted && alreadyCompleted.status !== "uploading")
        return alreadyCompleted;
      fail(409, "UPLOAD_CHANGED", "Upload is no longer available");
    }
    await tx.upload.delete({ where: { id: up.id } });
    const asset = await tx.asset.update({
      where: { id: up.assetId },
      data: { status: "processing" },
    });
    await enqueue(tx, "process-asset", {
      assetId: asset.id,
      objectKey: up.objectKey,
    });
    return asset;
  });
  return assetDto(updated);
});
app.delete("/v1/uploads/:uploadId", async (req) => {
  const u = await userFor(req);
  const { uploadId } = req.params as any;
  const up = await prisma.upload.findFirst({
    where: { assetId: uploadId, asset: { app: { ownerId: u.id } } },
    include: { asset: true },
  });
  if (!up) fail(404, "NOT_FOUND", "Upload not found");
  await abortMultipart(up.objectKey, up.multipartId).catch(() => {});
  await prisma.upload.delete({ where: { id: up.id } });
  await prisma.asset.delete({ where: { id: up.assetId } });
  return { ok: true };
});
app.get("/v1/assets/:id/thumbnail", async (req, reply) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const a = await prisma.asset.findFirst({
    where: { id, deletedAt: null, app: { ownerId: u.id, deletedAt: null } },
  });
  if (!a?.thumbnailKey) fail(404, "NOT_FOUND", "Thumbnail not found");
  return reply.redirect(await signedObject(a.thumbnailKey, 120));
});
app.get("/v1/assets/:id/preview", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const a = await prisma.asset.findFirst({
    where: {
      id,
      deletedAt: null,
      app: { ownerId: u.id, deletedAt: null },
      status: "ready",
    },
  });
  if (!a?.sourceKey) fail(404, "NOT_FOUND", "Asset preview not found");
  return {
    url: await signedObject(a.sourceKey, 300),
    expiresAt: new Date(Date.now() + 300_000).toISOString(),
    mimeType: a.mimeType,
  };
});

app.get("/v1/screens", async (req) => {
  const u = await userFor(req);
  const screens = await prisma.screen.findMany({
    where: { ownerId: u.id },
    orderBy: { createdAt: "desc" },
  });
  return {
    items: await screenDtosWithLatestTelemetry(screens),
  };
});
app.get("/v1/screens/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  return screenDtoWithLatestTelemetry(await ownerScreen(u.id, id));
});
app.post(
  "/v1/screens/pair",
  { config: { rateLimit: { max: 10, timeWindow: "15 minutes" } } },
  async (req) => {
    const u = await userFor(req);
    const b = z
      .object({
        code: z.string().length(8),
        name: z.string().trim().min(1).max(120),
      })
      .parse(req.body);
    const pairing = await prisma.pairing.findFirst({
      where: {
        codeHash: digest(b.code),
        expiresAt: { gt: new Date() },
        claimedAt: null,
      },
    });
    if (!pairing) fail(404, "NOT_FOUND", "Pairing code is invalid or expired");
    const token = randomSecret();
    const screenId = randomUUID();
    const result = await prisma.$transaction(async (tx) => {
      const claimed = await tx.pairing.updateMany({
        where: {
          id: pairing.id,
          claimedAt: null,
          expiresAt: { gt: new Date() },
        },
        data: { claimedAt: new Date(), encryptedDeviceToken: encrypt(token) },
      });
      if (!claimed.count)
        fail(409, "ALREADY_CLAIMED", "Pairing code has already been claimed");
      const s = await tx.screen.create({
        data: {
          id: screenId,
          ownerId: u.id,
          name: b.name,
          deviceId: pairing.deviceId,
          deviceTokenHash: digest(token),
          deviceTokenCiphertext: encrypt(token),
          capabilities: asJson(pairing.capabilities),
          status: "offline",
          desiredStates: {
            create: {
              version: 1,
              campaignId: null,
              orientation: 0,
              muted: true,
              volume: 50,
            },
          },
        },
      });
      await tx.pairing.update({
        where: { id: pairing.id },
        data: { screenId },
      });
      await saveManifest(tx, s);
      return s;
    });
    await notifyScreen(result.id, result.desiredVersion);
    return screenDtoWithLatestTelemetry(result);
  },
);
app.patch("/v1/screens/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  const b = screenPatchSchema.parse(req.body);
  const result = await prisma.$transaction(async (tx) => {
    const initial = await tx.screen.findFirst({
      where: { id, ownerId: u.id },
    });
    if (!initial) fail(404, "NOT_FOUND", "Screen not found");
    const campaignIds = [...new Set([initial.campaignId, b.campaignId])]
      .filter((campaignId): campaignId is string => Boolean(campaignId))
      .sort();
    const appRows = campaignIds.length
      ? await tx.campaign.findMany({
          where: { id: { in: campaignIds } },
          select: { appId: true },
        })
      : [];
    for (const appId of [...new Set(appRows.map((row) => row.appId))].sort())
      await tx.$queryRaw`SELECT "id" FROM "App" WHERE "id" = ${appId}::uuid FOR UPDATE`;
    for (const campaignId of campaignIds)
      await tx.$queryRaw`SELECT "id" FROM "Campaign" WHERE "id" = ${campaignId}::uuid FOR UPDATE`;
    const s = await tx.screen.findFirst({ where: { id, ownerId: u.id } });
    if (!s) fail(404, "NOT_FOUND", "Screen not found");
    if (s.desiredVersion !== b.expectedDesiredVersion)
      fail(409, "VERSION_CONFLICT", "Screen desired version has changed");
    if (b.campaignId) {
      const c = await tx.campaign.findFirst({
        where: {
          id: b.campaignId,
          app: { ownerId: u.id, deletedAt: null },
          status: "ready",
          currentRevision: { not: null },
        },
      });
      if (!c) fail(422, "INVALID_CAMPAIGN", "Campaign must be owned and ready");
      const currentRevision = c.currentRevision;
      if (currentRevision === null)
        fail(422, "INVALID_CAMPAIGN", "Campaign has no published revision");
      const items = await tx.campaignItem.findMany({
        where: { revision: { campaignId: c.id, revision: currentRevision } },
        include: { asset: true },
      });
      if (items.some((i: any) => i.asset.appId !== c.appId))
        fail(
          422,
          "INVALID_CAMPAIGN",
          "Campaign contains assets outside its app",
        );
    }
    const updated = await tx.screen.updateMany({
      where: { id, ownerId: u.id, desiredVersion: b.expectedDesiredVersion },
      data: {
        ...(b.name ? { name: b.name } : {}),
        ...(b.campaignId !== undefined ? { campaignId: b.campaignId } : {}),
        ...(b.orientation !== undefined ? { orientation: b.orientation } : {}),
        ...(b.muted !== undefined ? { muted: b.muted } : {}),
        ...(b.volume !== undefined ? { volume: b.volume } : {}),
        desiredVersion: { increment: 1 },
        status: b.campaignId === null ? "ready" : "preparing",
      },
    });
    if (!updated.count)
      fail(409, "VERSION_CONFLICT", "Screen desired version has changed");
    const saved = await tx.screen.findUnique({ where: { id } });
    const campaignRevision = saved!.campaignId
      ? ((
          await tx.campaign.findUnique({
            where: { id: saved!.campaignId },
            select: { currentRevision: true },
          })
        )?.currentRevision ?? null)
      : null;
    await tx.desiredState.create({
      data: {
        screenId: id,
        version: saved!.desiredVersion,
        campaignId: saved!.campaignId,
        campaignRevision,
        orientation: saved!.orientation,
        muted: saved!.muted,
        volume: saved!.volume,
      },
    });
    await saveManifest(tx, saved);
    return saved;
  });
  await notifyScreen(result!.id, result!.desiredVersion);
  return screenDtoWithLatestTelemetry(result);
});
app.delete("/v1/screens/:id", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  await ownerScreen(u.id, id);
  await prisma.$transaction([
    prisma.pairing.updateMany({
      where: { screenId: id },
      data: { screenId: null, encryptedDeviceToken: null },
    }),
    prisma.screen.delete({ where: { id } }),
  ]);
  for (const socket of sockets.get(id) ?? [])
    socket.close(4404, "screen removed");
  sockets.delete(id);
  return { ok: true };
});
app.get("/v1/screens/:id/telemetry", async (req) => {
  const u = await userFor(req);
  const { id } = req.params as any;
  await ownerScreen(u.id, id);
  const hours = Math.max(
    1,
    Math.min(168, Number((req.query as any)?.hours ?? 24)),
  );
  const rows = await prisma.telemetry.findMany({
    where: {
      screenId: id,
      sampledAt: { gte: new Date(Date.now() - hours * 3600_000) },
    },
    orderBy: { sampledAt: "desc" },
    take: 10000,
  });
  return {
    items: rows.map((t) => ({
      sampledAt: t.sampledAt.toISOString(),
      ...(t.payload as any),
    })),
  };
});

app.post(
  "/v1/device/pairing",
  { config: { rateLimit: { max: 10, timeWindow: "15 minutes" } } },
  async (req) => {
    const b = pairingRequestSchema.parse(req.body);
    const pairingId = randomUUID(),
      code = newPairingCode(),
      pollToken = randomSecret();
    const expiresAt = new Date(Date.now() + 10 * 60_000);
    await prisma.pairing.create({
      data: {
        id: pairingId,
        deviceId: b.deviceId,
        codeHash: digest(code),
        pollTokenHash: digest(pollToken),
        capabilities: asJson(b.capabilities),
        expiresAt,
      },
    });
    return { pairingId, code, pollToken, expiresAt: expiresAt.toISOString() };
  },
);
app.post("/v1/device/pairing/:pairingId/poll", async (req) => {
  const { pairingId } = req.params as any;
  const b = z.object({ pollToken: z.string().min(32) }).parse(req.body);
  const p = await prisma.pairing.findUnique({
    where: { id: pairingId },
    include: { screen: true },
  });
  if (!p || p.pollTokenHash !== digest(b.pollToken))
    fail(404, "NOT_FOUND", "Pairing request not found");
  if (p.expiresAt < new Date()) return { status: "expired" };
  if (!p.claimedAt) return { status: "pending" };
  const token = p.encryptedDeviceToken
    ? decrypt(p.encryptedDeviceToken)
    : undefined;
  return {
    status: "claimed",
    ...(token ? { deviceToken: token } : {}),
    ...(p.screenId ? { screenId: p.screenId } : {}),
  };
});
app.put("/v1/device/capabilities", async (req) => {
  const screen = await requireDevice(req);
  const b = capabilitiesSchema.parse(req.body);
  const n = await prisma.$transaction(async (tx) => {
    const initial = await tx.screen.findUnique({
      where: { id: screen.id },
      select: { campaignId: true },
    });
    if (!initial) fail(404, "NOT_FOUND", "Screen not found");
    if (initial.campaignId)
      await tx.$queryRaw`SELECT "id" FROM "Campaign" WHERE "id" = ${initial.campaignId}::uuid FOR UPDATE`;
    const current = await tx.screen.findUnique({ where: { id: screen.id } });
    if (!current) fail(404, "NOT_FOUND", "Screen not found");
    if (current.campaignId !== initial.campaignId)
      fail(
        409,
        "VERSION_CONFLICT",
        "Screen assignment changed; retry capabilities update",
      );
    if (isDeepStrictEqual(current.capabilities, b))
      return current;
    const updated = await tx.screen.updateMany({
      where: { id: screen.id, desiredVersion: current.desiredVersion },
      data: {
        capabilities: asJson(b),
        desiredVersion: { increment: 1 },
        status: current.campaignId ? "preparing" : "ready",
      },
    });
    if (!updated.count)
      fail(409, "VERSION_CONFLICT", "Screen desired version has changed");
    const saved = await tx.screen.findUnique({ where: { id: screen.id } });
    if (!saved) fail(404, "NOT_FOUND", "Screen not found");
    const campaignRevision = saved.campaignId
      ? ((
          await tx.campaign.findUnique({
            where: { id: saved.campaignId },
            select: { currentRevision: true },
          })
        )?.currentRevision ?? null)
      : null;
    await tx.desiredState.create({
      data: {
        screenId: saved.id,
        version: saved.desiredVersion,
        campaignId: saved.campaignId,
        campaignRevision,
        orientation: saved.orientation,
        muted: saved.muted,
        volume: saved.volume,
      },
    });
    await saveManifest(tx, saved);
    return saved;
  });
  await notifyScreen(n.id, n.desiredVersion);
  return screenDtoWithLatestTelemetry(n);
});
app.get("/v1/device/manifest", async (req, reply) => {
  const screen = await requireDevice(req);
  const manifest = await prisma.manifestRecord.findUnique({
    where: {
      screenId_version: { screenId: screen.id, version: screen.desiredVersion },
    },
  });
  if (!manifest) {
    await prisma.screen.update({
      where: { id: screen.id },
      data: { status: "preparing" },
    });
    return reply.code(204).send();
  }
  return manifest.body;
});
app.post("/v1/device/downloads", async (req) => {
  const screen = await requireDevice(req);
  const b = z
    .object({ renditionIds: z.array(z.string().uuid()).min(1).max(200) })
    .parse(req.body);
  const manifests = await prisma.manifestRecord.findMany({
    where: {
      screenId: screen.id,
      version: { gte: Math.max(1, screen.desiredVersion - 1) },
    },
    orderBy: { version: "desc" },
    take: 2,
  });
  const allowed = new Set(
    manifests.flatMap((m) =>
      ((m.body as any).items ?? []).map((i: any) => i.renditionId),
    ),
  );
  if (b.renditionIds.some((id) => !allowed.has(id)))
    fail(
      403,
      "FORBIDDEN",
      "Rendition is outside the authorized current and previous manifests",
    );
  const rows = await prisma.rendition.findMany({
    where: { id: { in: b.renditionIds } },
  });
  if (rows.length !== b.renditionIds.length)
    fail(404, "NOT_FOUND", "Rendition not found");
  return {
    downloads: await Promise.all(
      rows.map(async (r) => ({
        renditionId: r.id,
        url: await signedObject(r.objectKey, 600),
        expiresAt: new Date(Date.now() + 600_000).toISOString(),
      })),
    ),
  };
});
app.post("/v1/device/ack", async (req) => {
  const screen = await requireDevice(req);
  const b = playbackAckSchema.parse(req.body);
  if (b.version > screen.desiredVersion)
    fail(
      422,
      "FUTURE_VERSION",
      "Acknowledgement version is newer than desired state",
    );
  const manifest = await prisma.manifestRecord.findUnique({
    where: { screenId_version: { screenId: screen.id, version: b.version } },
  });
  if (!manifest)
    fail(
      422,
      "UNKNOWN_VERSION",
      "Acknowledgement version is not in an issued manifest",
    );
  const reportsPlaybackVersion =
    b.status === "error" && b.playingVersion !== undefined;
  if (
    b.status !== "error" &&
    b.playingVersion !== undefined &&
    b.playingVersion !== b.version
  )
    fail(
      422,
      "INVALID_PLAYING_VERSION",
      "Successful playback acknowledgements must report their acknowledged version",
    );
  if (
    b.status === "error" &&
    b.playingVersion !== undefined &&
    b.playingVersion !== null &&
    b.playingVersion > b.version
  )
    fail(
      422,
      "INVALID_PLAYING_VERSION",
      "Playback cannot be from a version newer than the reported error",
    );
  let playbackManifest: any = manifest;
  if (b.status === "error" && b.playingVersion !== undefined) {
    const reportedPlayingVersion = b.playingVersion;
    if (reportedPlayingVersion === null) {
      if (b.currentItemId)
        fail(
          422,
          "INVALID_ITEM",
          "A stopped renderer cannot report a current item",
        );
    } else {
      playbackManifest = await prisma.manifestRecord.findUnique({
        where: {
          screenId_version: {
            screenId: screen.id,
            version: reportedPlayingVersion,
          },
        },
      });
      if (!playbackManifest)
        fail(
          422,
          "UNKNOWN_PLAYING_VERSION",
          "Reported playback version is not in an issued manifest",
        );
    }
  }
  const itemIds = new Set(
    ((playbackManifest?.body as any)?.items ?? []).map((i: any) => i.id),
  );
  if (b.currentItemId && !itemIds.has(b.currentItemId))
    fail(
      422,
      "INVALID_ITEM",
      "Current item is not part of the acknowledged manifest",
    );
  if (b.status === "idle" && itemIds.size !== 0)
    fail(422, "INVALID_STATUS", "Idle is only valid for an empty manifest");
  if (b.status === "playing" && itemIds.size === 0)
    fail(
      422,
      "INVALID_STATUS",
      "Playing is only valid for a non-empty manifest",
    );
  const nowPlaying = screen.playingVersion ?? 0;
  const successfulPlayback = b.status === "playing" || b.status === "idle";
  if (b.status === "error" && b.version < screen.desiredVersion)
    return { ok: true, stale: true };
  if (b.status === "error" && b.version < nowPlaying)
    return { ok: true, stale: true };
  if (b.status === "downloading" && b.version <= nowPlaying)
    return { ok: true, stale: true };
  if (successfulPlayback && b.version < nowPlaying)
    return { ok: true, stale: true };
  if (
    successfulPlayback &&
    b.version === nowPlaying &&
    screen.status !== "error" &&
    !screen.error
  )
    return { ok: true, stale: true };
  const set: any = {};
  if (b.version >= screen.desiredVersion) {
    set.status =
      b.status === "error" ? "error" : b.status === "idle" ? "ready" : b.status;
    set.error =
      b.status === "error"
        ? (b.error ?? "Device reported playback error")
        : null;
  }
  if (b.status === "playing" || b.status === "idle")
    set.playingVersion = b.version;
  else if (reportsPlaybackVersion) set.playingVersion = b.playingVersion;
  const updatesPlayback =
    successfulPlayback || (b.status === "error" && reportsPlaybackVersion);
  const updated = await prisma.screen.updateMany({
    where: {
      id: screen.id,
      desiredVersion: screen.desiredVersion,
      ...(updatesPlayback
        ? {
            OR: [
              { playingVersion: null },
              { playingVersion: { lte: b.version } },
            ],
          }
        : {}),
    },
    data: set,
  });
  return { ok: true, stale: updated.count === 0 };
});
app.post("/v1/device/telemetry", async (req) => {
  const screen = await requireDevice(req);
  const b = z
    .object({ samples: z.array(telemetrySampleSchema).min(1).max(100) })
    .parse(req.body);
  await prisma.$transaction(async (tx) => {
    for (const sample of b.samples) {
      const key = digest(JSON.stringify(sample));
      await tx.telemetry.createMany({
        data: [
          {
            screenId: screen.id,
            sampledAt: new Date(sample.sampledAt),
            payload: asJson(sample),
            dedupeKey: key,
          },
        ],
        skipDuplicates: true,
      });
    }
  });
  return { accepted: b.samples.length };
});
app.get("/v1/device/events", { websocket: true }, (socket, req) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    socket.close(4401, "auth required");
    return;
  }
  const token = authHeader.slice(7);
  void prisma.screen
    .findFirst({ where: { deviceTokenHash: digest(token) } })
    .then((screen) => {
      if (!screen) {
        socket.close(4401, "invalid token");
        return;
      }
      let set = sockets.get(screen.id);
      if (!set) {
        set = new Set();
        sockets.set(screen.id, set);
      }
      set.add(socket);
      socket.on("close", () => {
        set!.delete(socket);
        if (!set!.size) sockets.delete(screen.id);
      });
      socket.on("error", (error: Error) => {
        req.log.warn({ err: error }, "device WebSocket error");
        set!.delete(socket);
        if (!set!.size) sockets.delete(screen.id);
      });
      void prisma.screen
        .updateMany({
          where: { id: screen.id },
          data: { lastSeenAt: new Date() },
        })
        .catch((error) =>
          req.log.error(error, "failed to update device last-seen"),
        );
      void prisma.screen
        .findUnique({
          where: { id: screen.id },
          select: { desiredVersion: true },
        })
        .then((current) => {
          if (current && socket.readyState === 1)
            socket.send(
              JSON.stringify({
                type: "desired-state",
                version: current.desiredVersion,
              }),
            );
        })
        .catch((error) => req.log.error(error));
    })
    .catch((error) => {
      req.log.error(error, "device WebSocket authentication failed");
      if (socket.readyState === 1) socket.close(1011, "authentication failed");
    });
});
const listener = new Pool({ connectionString: config.databaseUrl });
let listenClient: any;
let listenerRetry: NodeJS.Timeout | undefined;
let listenerAttempt = 0;
let listenerConnecting = false;
let listenerStopped = false;
const scheduleListenerReconnect = () => {
  if (listenerStopped || listenerRetry) return;
  const delay = Math.min(30_000, 1_000 * 2 ** listenerAttempt++);
  listenerRetry = setTimeout(() => {
    listenerRetry = undefined;
    void connectListener();
  }, delay);
  listenerRetry.unref();
};
const connectListener = async () => {
  if (listenerStopped || listenerConnecting) return;
  listenerConnecting = true;
  try {
    const client = await listener.connect();
    listenClient = client;
    const disconnect = (error: Error) => {
      if (listenClient !== client) return;
      listenClient = undefined;
      app.log.error(
        { err: error },
        "PostgreSQL notification listener disconnected",
      );
      client.release(true);
      scheduleListenerReconnect();
    };
    client.on("error", disconnect);
    client.once("end", () =>
      disconnect(new Error("PostgreSQL listener ended")),
    );
    await client.query("LISTEN pixel8_screen");
    listenerAttempt = 0;
    client.on("notification", (msg: { payload?: string }) => {
      try {
        const event = JSON.parse(msg.payload ?? "{}");
        for (const socket of sockets.get(event.screenId) ?? [])
          if (socket.readyState === 1)
            socket.send(
              JSON.stringify({
                type: "desired-state",
                version: event.version,
              }),
            );
      } catch (e) {
        app.log.error(e);
      }
    });
  } catch (error) {
    app.log.error(
      error,
      "Unable to establish PostgreSQL notification listener",
    );
    if (listenClient) {
      listenClient.release(true);
      listenClient = undefined;
    }
    scheduleListenerReconnect();
  } finally {
    listenerConnecting = false;
  }
};
void connectListener();
const outbox = setInterval(async () => {
  try {
    const rows = await prisma.job.findMany({
      where: { processedAt: null },
      orderBy: { createdAt: "asc" },
      take: 50,
    });
    for (const row of rows) {
      try {
        const jobId = await boss.send(row.type, asJson(row.payload), {
          id: row.id,
        });
        if (!jobId) {
          const existing = await boss.getJobById(row.type, row.id, {
            includeArchive: true,
          });
          if (!existing)
            throw new Error(`pg-boss did not accept outbox job ${row.id}`);
        }
        await prisma.job.updateMany({
          where: { id: row.id, processedAt: null },
          data: {
            processedAt: new Date(),
            attempts: { increment: 1 },
            error: null,
          },
        });
      } catch (error) {
        await prisma.job.updateMany({
          where: { id: row.id, processedAt: null },
          data: {
            attempts: { increment: 1 },
            error: String(error).slice(0, 2000),
          },
        });
        throw error;
      }
    }
  } catch (e) {
    app.log.error(e);
  }
}, 1000);
outbox.unref();
const recoverOutbox = async () => {
  try {
    const rows = await prisma.job.findMany({
      where: {
        processedAt: { not: null },
        createdAt: { gte: new Date(Date.now() - 7 * 24 * 3600_000) },
      },
      orderBy: { processedAt: "desc" },
      take: 100,
    });
    for (const row of rows) {
      const existing = await boss.getJobById(row.type, row.id, {
        includeArchive: true,
      });
      if (!existing)
        await prisma.job.updateMany({
          where: { id: row.id, processedAt: row.processedAt },
          data: {
            processedAt: null,
            error: "Recovered outbox row whose pg-boss job was missing",
          },
        });
    }
  } catch (error) {
    app.log.error(error, "pg-boss outbox recovery failed");
  }
};
void recoverOutbox();
const outboxRecovery = setInterval(() => void recoverOutbox(), 5 * 60_000);
outboxRecovery.unref();
const reconcile = setInterval(async () => {
  try {
    for (const [screenId, clients] of sockets) {
      const s = await prisma.screen.findUnique({
        where: { id: screenId },
        select: { desiredVersion: true },
      });
      if (!s) {
        for (const socket of clients) socket.close(4404, "screen removed");
        sockets.delete(screenId);
        continue;
      }
      for (const socket of clients)
        if (socket.readyState === 1)
          socket.send(
            JSON.stringify({
              type: "desired-state",
              version: s.desiredVersion,
            }),
          );
    }
  } catch (e) {
    app.log.error(e);
  }
}, 30_000);
reconcile.unref();
await app.listen({ port: config.port, host: "0.0.0.0" });
const shutdown = async () => {
  clearInterval(outbox);
  clearInterval(outboxRecovery);
  clearInterval(reconcile);
  listenerStopped = true;
  if (listenerRetry) clearTimeout(listenerRetry);
  await app.close();
  await boss.stop({ timeout: 10_000 });
  listenClient?.release();
  await listener.end();
  await pg.end();
  await prisma.$disconnect();
  process.exit(0);
};
process.on("SIGTERM", () => void shutdown());
process.on("SIGINT", () => void shutdown());
