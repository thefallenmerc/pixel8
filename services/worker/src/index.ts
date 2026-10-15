import { createHash } from "node:crypto";
import { mkdtemp, rm, stat, readFile, writeFile } from "node:fs/promises";
import { createReadStream } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { spawn } from "node:child_process";
import { pipeline } from "node:stream/promises";
import { Readable } from "node:stream";
import PgBoss from "pg-boss";
import sharp from "sharp";
import {
  GetObjectCommand,
  PutObjectCommand,
  S3Client,
  HeadObjectCommand,
} from "@aws-sdk/client-s3";
import { prisma } from "@pixel8/database";
import { aggregateExpiredTelemetry } from "./retention.js";

const databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl) throw new Error("DATABASE_URL is required");
const bucket = process.env.S3_BUCKET ?? "pixel8";
const s3 = new S3Client({
  region: process.env.S3_REGION ?? "auto",
  endpoint: process.env.S3_ENDPOINT ?? "http://localhost:19000",
  forcePathStyle: (process.env.S3_FORCE_PATH_STYLE ?? "true") === "true",
  credentials: {
    accessKeyId: process.env.S3_ACCESS_KEY_ID ?? "minioadmin",
    secretAccessKey: process.env.S3_SECRET_ACCESS_KEY ?? "minioadmin",
  },
});
const boss = new PgBoss({ connectionString: databaseUrl });
boss.on("error", (error) => console.error("pg-boss runtime error", error));
const hash = (b: Buffer | string) =>
  createHash("sha256").update(b).digest("hex");
async function hashFile(path: string) {
  const h = createHash("sha256");
  for await (const chunk of createReadStream(path)) h.update(chunk);
  return h.digest("hex");
}
const run = (bin: string, args: string[], timeoutMs = 10 * 60_000) =>
  new Promise<void>((resolve, reject) => {
    const p = spawn(bin, args, { stdio: ["ignore", "ignore", "pipe"] });
    let err = "";
    const timer = setTimeout(() => {
      p.kill("SIGKILL");
      reject(new Error(`${bin} timed out after ${timeoutMs}ms`));
    }, timeoutMs);
    p.stderr.on("data", (d) => {
      err += d.toString();
      if (err.length > 12000) err = err.slice(-12000);
    });
    p.on("error", (e) => {
      clearTimeout(timer);
      reject(e);
    });
    p.on("close", (code) => {
      clearTimeout(timer);
      code === 0
        ? resolve()
        : reject(new Error(`${bin} exited ${code}: ${err}`));
    });
  });
const download = async (key: string, path: string) => {
  const obj = await s3.send(new GetObjectCommand({ Bucket: bucket, Key: key }));
  if (!obj.Body) throw new Error("Source object has no body");
  await pipeline(
    obj.Body as Readable,
    await import("node:fs").then((fs) => fs.createWriteStream(path)),
  );
};
const ffmpeg = process.env.FFMPEG_PATH ?? "ffmpeg";
const ffprobe = process.env.FFPROBE_PATH ?? "ffprobe";
async function probe(path: string) {
  return new Promise<any>((resolve, reject) => {
    const p = spawn(
      ffprobe,
      [
        "-v",
        "error",
        "-show_entries",
        "format=duration,format_name:stream=codec_type,codec_name,width,height",
        "-of",
        "json",
        path,
      ],
      { stdio: ["ignore", "pipe", "pipe"] },
    );
    let out = "",
      err = "";
    const timer = setTimeout(() => {
      p.kill("SIGKILL");
      reject(new Error("ffprobe timed out"));
    }, 30_000);
    p.stdout.on("data", (x) => {
      out += x;
      if (out.length > 2_000_000) {
        p.kill("SIGKILL");
        reject(new Error("ffprobe response exceeded limit"));
      }
    });
    p.stderr.on("data", (x) => {
      err += x;
      if (err.length > 12_000) err = err.slice(-12_000);
    });
    p.on("error", (e) => {
      clearTimeout(timer);
      reject(e);
    });
    p.on("close", (c) => {
      clearTimeout(timer);
      if (c !== 0) return reject(new Error(`ffprobe failed: ${err}`));
      try {
        resolve(JSON.parse(out));
      } catch (e) {
        reject(e);
      }
    });
  });
}
async function makeImageVideo(
  source: string,
  target: string,
  duration: number,
  width: number,
  height: number,
  fit: string,
  orientation: number,
) {
  const converted = source + ".png";
  try {
    const image = await sharp(source, { failOn: "error" })
      .rotate()
      .png()
      .toBuffer();
    await writeFile(converted, image);
  } catch {
    try {
      await run(process.env.HEIF_CONVERT_PATH ?? "heif-convert", [
        "-q",
        "90",
        source,
        source + ".jpg",
      ]);
      await run(ffmpeg, [
        "-i",
        source + ".jpg",
        "-frames:v",
        "1",
        "-y",
        converted,
      ]);
    } catch {
      await run(ffmpeg, ["-i", source, "-frames:v", "1", "-y", converted]);
    }
  }
  await encode(
    converted,
    target,
    duration,
    width,
    height,
    fit,
    orientation,
    true,
  );
}
async function inspectImage(source: string) {
  try {
    const image = sharp(source, { failOn: "error" }).rotate();
    const metadata = await image.metadata();
    // `sharp.metadata()` can read an HEIC container without a decoder plugin.
    // Force a decode here so thumbnail generation can select a real fallback.
    const decoded = await image.jpeg({ quality: 90 }).toBuffer();
    const thumbnailSource = `${source}.decoded.jpg`;
    await writeFile(thumbnailSource, decoded);
    return {
      metadata,
      thumbnailSource,
    };
  } catch {
    const jpeg = `${source}.heif.jpg`;
    try {
      await run(
        process.env.HEIF_CONVERT_PATH ?? "heif-convert",
        ["-q", "90", source, jpeg],
        30_000,
      );
    } catch {
      await run(
        ffmpeg,
        ["-i", source, "-frames:v", "1", "-q:v", "2", "-y", jpeg],
        30_000,
      );
    }
    return {
      metadata: await sharp(jpeg, { failOn: "error" }).metadata(),
      thumbnailSource: jpeg,
    };
  }
}
function filterFor(
  width: number,
  height: number,
  fit: string,
  orientation: number,
) {
  const turn = orientation === 90 || orientation === 270;
  const inW = turn ? height : width,
    inH = turn ? width : height;
  const base =
    fit === "cover"
      ? `scale=${inW}:${inH}:force_original_aspect_ratio=increase,crop=${inW}:${inH}`
      : `scale=${inW}:${inH}:force_original_aspect_ratio=decrease,pad=${inW}:${inH}:(ow-iw)/2:(oh-ih)/2:color=black`;
  const rotate =
    orientation === 90
      ? ",transpose=clock"
      : orientation === 180
        ? ",hflip,vflip"
        : orientation === 270
          ? ",transpose=cclock"
          : "";
  return `${base}${rotate},setsar=1,fps=30,format=yuv420p`;
}
async function encode(
  source: string,
  target: string,
  duration: number,
  width: number,
  height: number,
  fit: string,
  orientation: number,
  image = false,
  hasAudio = false,
) {
  const vf = filterFor(width, height, fit, orientation);
  const input = image
    ? ["-loop", "1", "-i", source]
    : ["-stream_loop", "-1", "-i", source];
  const args = [
    ...input,
    "-f",
    "lavfi",
    "-i",
    "anullsrc=channel_layout=stereo:sample_rate=48000",
    "-t",
    String(duration),
    "-map",
    "0:v:0",
  ];
  if (hasAudio)
    args.push(
      "-filter_complex",
      `[0:a:0]aresample=48000,aformat=channel_layouts=stereo,apad=whole_dur=${duration},atrim=duration=${duration}[a]`,
      "-map",
      "[a]",
    );
  else args.push("-map", "1:a:0");
  args.push(
    "-vf",
    vf,
    "-r",
    "30",
    "-vsync",
    "cfr",
    "-c:v",
    "libx264",
    "-profile:v",
    "main",
    "-level:v",
    "4.1",
    "-maxrate",
    "10000k",
    "-bufsize",
    "20000k",
    "-preset",
    process.env.FFMPEG_PRESET ?? "veryfast",
    "-crf",
    process.env.FFMPEG_CRF ?? "22",
    "-pix_fmt",
    "yuv420p",
    "-c:a",
    "aac",
    "-b:a",
    "128k",
    "-ar",
    "48000",
    "-ac",
    "2",
    "-movflags",
    "+faststart",
    "-shortest",
    target,
  );
  await run(ffmpeg, args);
}
async function putFile(key: string, path: string, mimeType: string) {
  const [metadata, sha256] = await Promise.all([stat(path), hashFile(path)]);
  await s3.send(
    new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: createReadStream(path),
      ContentLength: metadata.size,
      ContentType: mimeType,
    }),
  );
  return { sha256, sizeBytes: metadata.size };
}
async function assetJob(data: any) {
  const asset = await prisma.asset.findUnique({ where: { id: data.assetId } });
  if (!asset || asset.status === "ready") return;
  const dir = await mkdtemp(join(tmpdir(), "pixel8-"));
  try {
    const source = join(dir, "source");
    await download(asset.sourceKey ?? data.objectKey, source);
    const sourceHash = await hashFile(source);
    const image = asset.mimeType.toLowerCase().startsWith("image/");
    let info: any,
      first: any,
      thumbnailSource = source;
    if (image) {
      const checked = await inspectImage(source);
      first = checked.metadata;
      thumbnailSource = checked.thumbnailSource;
    } else {
      info = await probe(source);
      first = info.streams?.find((s: any) => s.codec_type === "video");
      if (!first)
        throw new Error("No video stream found in declared video upload");
      const format = String(info.format?.format_name ?? "").toLowerCase(),
        mime = asset.mimeType.toLowerCase();
      const valid =
        mime === "video/mp4" || mime === "video/quicktime"
          ? /(^|,)(mov|mp4|m4a|3gp|3g2|mj2)(,|$)/.test(format)
          : mime === "video/webm"
            ? format.includes("webm")
            : format.includes("matroska");
      if (!valid)
        throw new Error(
          `Declared media type ${mime} does not match detected container ${format || "unknown"}`,
        );
    }
    const width = Number(first.width),
      height = Number(first.height);
    if (!width || !height || width * height > 100_000_000)
      throw new Error("Invalid or excessively large media dimensions");
    let thumbData: Buffer;
    if (image) {
      thumbData = await sharp(thumbnailSource, { failOn: "error" })
        .rotate()
        .resize({
          width: 480,
          height: 270,
          fit: "inside",
          withoutEnlargement: true,
        })
        .jpeg({ quality: 82 })
        .toBuffer();
    } else {
      const shot = join(dir, "frame.jpg");
      await run(
        ffmpeg,
        [
          "-ss",
          "0",
          "-i",
          source,
          "-frames:v",
          "1",
          "-vf",
          "scale=480:-2",
          "-y",
          shot,
        ],
        60_000,
      );
      thumbData = await readFile(shot);
    }
    await s3.send(
      new PutObjectCommand({
        Bucket: bucket,
        Key: `thumbnail/${asset.id}.jpg`,
        Body: thumbData,
        ContentType: "image/jpeg",
      }),
    );
    await prisma.asset.update({
      where: { id: asset.id },
      data: {
        sourceSha256: sourceHash,
        width,
        height,
        thumbnailKey: `thumbnail/${asset.id}.jpg`,
        status: "ready",
        error: null,
      },
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Media processing failed";
    await prisma.asset.update({
      where: { id: asset.id },
      data: { status: "failed", error: msg.slice(0, 2000) },
    });
    throw e;
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}
async function campaignJob(data: any) {
  const { campaignId, revision } = data;
  const revisionRow = await prisma.campaignRevision.findUnique({
    where: { campaignId_revision: { campaignId, revision } },
    include: {
      items: { include: { asset: true }, orderBy: { ordinal: "asc" } },
    },
  });
  const campaign = await prisma.campaign.findUnique({
    where: { id: campaignId },
  });
  if (!revisionRow || !campaign || revisionRow.status === "ready") return;
  const dir = await mkdtemp(join(tmpdir(), "pixel8-"));
  try {
    await prisma.campaignRevision.update({
      where: { id: revisionRow.id },
      data: { status: "processing" },
    });
    for (const item of revisionRow.items) {
      if (
        item.asset.status !== "ready" ||
        !item.asset.sourceKey ||
        !item.asset.sourceSha256
      )
        throw new Error(`Asset ${item.assetId} is not ready`);
      const source = join(dir, `${item.assetId}.source`);
      await download(item.asset.sourceKey, source);
      const isImage = item.asset.mimeType.startsWith("image/");
      const probeResult = isImage ? { streams: [] } : await probe(source);
      const duration = isImage
        ? Number(item.durationSeconds)
        : Number(probeResult.format?.duration);
      if (!Number.isFinite(duration) || duration <= 0 || duration > 86_400)
        throw new Error(`Media duration is invalid for asset ${item.assetId}`);
      for (const profile of ["720p30-v1", "1080p30-v1"]) {
        const w = profile.startsWith("1080") ? 1920 : 1280,
          h = profile.startsWith("1080") ? 1080 : 720;
        for (const orientation of [0, 90, 180, 270]) {
          const cacheKey = hash(
            JSON.stringify({
              assetId: item.assetId,
              sourceHash: item.asset.sourceSha256,
              profileVersion: profile,
              fit: item.fit,
              durationSeconds: duration,
              orientation,
            }),
          );
          let rendition = await prisma.rendition.findUnique({
            where: { cacheKey },
          });
          if (!rendition) {
            const output = join(
              dir,
              `${item.id}-${profile}-${orientation}.mp4`,
            );
            const hasAudio =
              probeResult.streams?.some((s: any) => s.codec_type === "audio") ??
              false;
            if (isImage)
              await makeImageVideo(
                source,
                output,
                duration,
                w,
                h,
                item.fit,
                orientation,
              );
            else
              await encode(
                source,
                output,
                duration,
                w,
                h,
                item.fit,
                orientation,
                false,
                hasAudio,
              );
            const objectKey = `renditions/${cacheKey}.mp4`;
            const result = await putFile(objectKey, output, "video/mp4");
            rendition = await prisma.rendition.create({
              data: {
                assetId: item.assetId,
                profile,
                cacheKey,
                fit: item.fit,
                durationSeconds: duration,
                orientation,
                objectKey,
                ...result,
                mimeType: "video/mp4",
                width: w,
                height: h,
              },
            });
          }
          await prisma.campaignItemVariant.upsert({
            where: {
              itemId_profile_orientation: {
                itemId: item.id,
                profile,
                orientation,
              },
            },
            create: {
              itemId: item.id,
              profile,
              orientation,
              renditionId: rendition.id,
            },
            update: { renditionId: rendition.id },
          });
        }
      }
    }
    await prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT "id" FROM "Campaign" WHERE "id" = ${campaignId}::uuid FOR UPDATE`;
      await tx.campaignRevision.update({
        where: { id: revisionRow.id },
        data: { status: "ready", error: null },
      });
      const publish = await tx.campaign.updateMany({
        where: { id: campaignId, revision },
        data: { currentRevision: revision, status: "ready", error: null },
      });
      if (!publish.count) return;
      const screens = await tx.screen.findMany({ where: { campaignId } });
      for (const screen of screens) {
        const claimed = await tx.screen.updateMany({
          where: {
            id: screen.id,
            campaignId,
            desiredVersion: screen.desiredVersion,
          },
          data: {
            desiredVersion: { increment: 1 },
            status: "preparing",
            error: null,
          },
        });
        if (!claimed.count) continue;
        const updated = await tx.screen.findUnique({
          where: { id: screen.id },
        });
        if (!updated || updated.campaignId !== campaignId) continue;
        const desired = {
          screenId: updated.id,
          version: updated.desiredVersion,
          campaignId: updated.campaignId,
          campaignRevision: revision,
          orientation: updated.orientation,
          muted: updated.muted,
          volume: updated.volume,
        };
        await tx.desiredState.create({ data: desired });
        const caps = updated.capabilities as any;
        const profile =
          caps?.supports1080p === true ? "1080p30-v1" : "720p30-v1";
        const publishedItems = await tx.campaignItem.findMany({
          where: { revisionId: revisionRow.id },
          include: {
            variants: {
              where: { profile, orientation: updated.orientation },
              include: { rendition: true },
            },
          },
          orderBy: { ordinal: "asc" },
        });
        if (publishedItems.some((item) => item.variants.length !== 1))
          throw new Error(`Missing rendition for screen ${updated.id}`);
        const manifest = {
          schemaVersion: 1,
          screenId: updated.id,
          version: updated.desiredVersion,
          profile,
          orientation: updated.orientation,
          muted: updated.muted,
          volume: updated.volume,
          items: publishedItems.map((item) => {
            const rendition = item.variants[0].rendition;
            return {
              id: item.id,
              assetId: item.assetId,
              renditionId: rendition.id,
              sha256: rendition.sha256,
              sizeBytes: Number(rendition.sizeBytes),
              durationMs: Math.round(rendition.durationSeconds * 1000),
            };
          }),
        };
        await tx.manifestRecord.create({
          data: {
            screenId: updated.id,
            version: updated.desiredVersion,
            body: manifest,
          },
        });
        await tx.$queryRaw`SELECT pg_notify('pixel8_screen', ${JSON.stringify({ screenId: updated.id, version: updated.desiredVersion })})::text AS notified`;
      }
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Campaign processing failed";
    await prisma.campaignRevision
      .update({
        where: { id: revisionRow.id },
        data: { status: "failed", error: msg.slice(0, 2000) },
      })
      .catch(() => {});
    await prisma.campaign
      .updateMany({
        where: { id: campaignId, revision },
        data: { status: "failed", error: msg.slice(0, 2000) },
      })
      .catch(() => {});
    throw e;
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

await boss.start();
await boss.createQueue("process-asset");
await boss.createQueue("process-campaign");
await boss.work("process-asset", async (jobs) => {
  for (const job of jobs) await assetJob(job.data);
});
await boss.work("process-campaign", async (jobs) => {
  for (const job of jobs) await campaignJob(job.data);
});
const cleanup = async () => {
  try {
    const rawCutoff = new Date(Date.now() - 30 * 24 * 3600_000);
    rawCutoff.setMinutes(0, 0, 0);
    await prisma.$transaction(async (tx) => {
      await aggregateExpiredTelemetry(tx, rawCutoff);
      await tx.telemetryAggregate.deleteMany({
        where: { hour: { lt: new Date(Date.now() - 90 * 24 * 3600_000) } },
      });
    });
  } catch (e) {
    console.error("telemetry aggregation/retention failed", e);
  }
};
const cleanupTimer = setInterval(() => void cleanup(), 6 * 3600_000);
cleanupTimer.unref();
void cleanup();
console.log("Pixel8 media worker started");
const shutdown = async () => {
  clearInterval(cleanupTimer);
  await boss.stop({ timeout: 10_000 });
  await prisma.$disconnect();
  process.exit(0);
};
process.on("SIGTERM", () => void shutdown());
process.on("SIGINT", () => void shutdown());
