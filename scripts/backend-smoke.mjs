import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { createHash, randomBytes, randomUUID } from "node:crypto";
import { prisma } from "../packages/database/dist/index.js";
import { aggregateExpiredTelemetry } from "../services/worker/dist/retention.js";
import { createRequire } from "node:module";

const base = (process.env.API_URL ?? "http://localhost:3001").replace(
  /\/$/,
  "",
);
const mailpit = (process.env.MAILPIT_URL ?? "http://127.0.0.1:18025").replace(
  /\/$/,
  "",
);
const cookieFile = process.env.OWNER_COOKIE_FILE;
const request = async (path, { cookie, token, method = "GET", body } = {}) => {
  const headers = {};
  if (cookie) headers.cookie = cookie;
  if (token) headers.authorization = `Bearer ${token}`;
  if (body !== undefined) headers["content-type"] = "application/json";
  const response = await fetch(`${base}${path}`, {
    method,
    headers,
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  const text = await response.text();
  return {
    status: response.status,
    body: text ? JSON.parse(text) : undefined,
    headers: response.headers,
  };
};
const fromCookieFile = async () => {
  try {
    const line = (await readFile(cookieFile, "utf8"))
      .split(/\r?\n/)
      .find((x) => x.includes("\tbetter-auth.session_token\t"));
    if (!line) return undefined;
    const fields = line.split("\t");
    return `${fields[5]}=${fields[6]}`;
  } catch {
    return undefined;
  }
};
let ownerCookie = process.env.OWNER_COOKIE;
const ok = (response, status, label) =>
  assert.equal(
    response.status,
    status,
    `${label}: ${JSON.stringify(response.body)}`,
  );
const json = async (url, init) => {
  const response = await fetch(url, init);
  const text = await response.text();
  return {
    status: response.status,
    body: text ? JSON.parse(text) : undefined,
    headers: response.headers,
  };
};
const uploadMedia = async ({ appId, name, mimeType, bytes }) => {
  const started = await request(`/v1/apps/${appId}/uploads`, {
    cookie: ownerCookie,
    method: "POST",
    body: { name, mimeType, sizeBytes: bytes.byteLength },
  });
  ok(started, 200, `start ${name} upload`);
  const grants = await request(`/v1/uploads/${started.body.uploadId}/parts`, {
    cookie: ownerCookie,
    method: "POST",
    body: { partNumbers: [1] },
  });
  ok(grants, 200, `grant ${name} upload part`);
  const part = await fetch(grants.body.parts[0].url, {
    method: "PUT",
    body: bytes,
    headers: { "content-type": mimeType },
  });
  assert.equal(part.status, 200, `${name} S3 multipart upload`);
  const complete = await request(
    `/v1/uploads/${started.body.uploadId}/complete`,
    {
      cookie: ownerCookie,
      method: "POST",
      body: { parts: [{ partNumber: 1, etag: part.headers.get("etag") }] },
    },
  );
  ok(complete, 200, `complete ${name} upload`);
  let asset = complete.body;
  for (
    let attempt = 0;
    attempt < 180 && !["ready", "failed"].includes(asset.status);
    attempt++
  ) {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    asset = (
      await request(`/v1/apps/${appId}/assets`, { cookie: ownerCookie })
    ).body.items.find((item) => item.id === started.body.uploadId);
  }
  assert.equal(
    asset.status,
    "ready",
    `${name} worker processing failed: ${JSON.stringify(asset)}`,
  );
  return asset;
};
const connectDeviceSocket = (record, apiUrl) => {
  const require = createRequire(import.meta.url);
  const WebSocket = require("../node_modules/.pnpm/ws@8.22.0/node_modules/ws/index.js");
  const eventsUrl = new URL("/v1/device/events", apiUrl);
  eventsUrl.protocol = eventsUrl.protocol === "https:" ? "wss:" : "ws:";
  const socket = new WebSocket(eventsUrl, {
    headers: { authorization: `Bearer ${record.token}` },
  });
  const messages = [];
  const waiters = new Set();
  socket.on("message", (message) => {
    let body;
    try {
      body = JSON.parse(message.toString());
    } catch {
      return;
    }
    messages.push(body);
    for (const waiter of waiters) {
      if (body.type === "desired-state" && body.version >= waiter.version) {
        clearTimeout(waiter.timeout);
        waiters.delete(waiter);
        waiter.resolve(body.version);
      }
    }
  });
  const opened = new Promise((resolve, reject) => {
    const timeout = setTimeout(
      () => reject(new Error("Device WebSocket open timed out")),
      10_000,
    );
    socket.once("open", () => {
      clearTimeout(timeout);
      resolve();
    });
    socket.once("error", (error) => {
      clearTimeout(timeout);
      reject(error);
    });
  });
  const waitForVersion = (version) => {
    const existing = messages.find(
      (message) =>
        message.type === "desired-state" && message.version >= version,
    );
    if (existing) return Promise.resolve(existing.version);
    return new Promise((resolve, reject) => {
      const waiter = { version, resolve, reject, timeout: undefined };
      waiter.timeout = setTimeout(() => {
        waiters.delete(waiter);
        reject(new Error(`Desired-state ${version} hint timed out`));
      }, 15_000);
      waiters.add(waiter);
    });
  };
  const close = () =>
    new Promise((resolve) => {
      if (socket.readyState === WebSocket.CLOSED) return resolve();
      socket.once("close", resolve);
      socket.close();
      setTimeout(() => {
        if (socket.readyState !== WebSocket.CLOSED) socket.terminate();
      }, 1000).unref();
    });
  return { opened, waitForVersion, close, socket };
};

let simulatorIds = [];
let smokeAppId;
try {
  // This local-only smoke exercises the OTP rate limiter itself. Remove only
  // its persisted counter so repeated smoke runs begin from the same state.
  await prisma.rateLimit.deleteMany({
    where: {
      OR: [
        { key: { endsWith: "|/email-otp/send-verification-otp" } },
        { key: { endsWith: "|/sign-in/email-otp" } },
      ],
    },
  });
  ok(await request("/ready"), 200, "database readiness");
  const preflight = await fetch(`${base}/v1/apps`, {
    method: "OPTIONS",
    headers: {
      origin: "http://localhost:3000",
      "access-control-request-method": "PATCH",
      "access-control-request-headers": "authorization,content-type",
    },
  });
  assert(
    preflight.headers.get("access-control-allow-methods")?.includes("PATCH"),
    "browser CORS preflight must permit campaign and screen edits",
  );
  assert(
    preflight.headers.get("access-control-allow-credentials") === "true",
    "browser CORS preflight must permit session credentials",
  );
  ownerCookie ??= await fromCookieFile();
  if (ownerCookie) {
    const session = await json(`${base}/api/auth/get-session`, {
      headers: { cookie: ownerCookie },
    });
    if (!session.body?.user) ownerCookie = undefined;
  }
  if (!ownerCookie) {
    const email =
      process.env.SMOKE_OWNER_EMAIL ??
      `backend-owner-${Date.now()}@pixel8.local`;
    ok(
      await json(`${base}/api/auth/email-otp/send-verification-otp`, {
        method: "POST",
        headers: {
          origin: "http://localhost:3000",
          "content-type": "application/json",
        },
        body: JSON.stringify({ email, type: "sign-in" }),
      }),
      200,
      "bootstrap OTP request",
    );
    let otp;
    for (let attempt = 0; attempt < 20 && !otp; attempt++) {
      const inbox = await json(`${mailpit}/api/v1/messages`);
      const message = inbox.body.messages.find((item) =>
        item.To?.some((to) => to.Address === email),
      );
      otp = message?.Snippet?.match(/\b\d{6}\b/)?.[0];
      if (!otp) await new Promise((resolve) => setTimeout(resolve, 250));
    }
    assert(otp, "owner bootstrap OTP was not delivered to Mailpit");
    const signIn = await json(`${base}/api/auth/sign-in/email-otp`, {
      method: "POST",
      headers: {
        origin: "http://localhost:3000",
        "content-type": "application/json",
      },
      body: JSON.stringify({ email, otp, name: "Backend smoke owner" }),
    });
    ok(signIn, 200, "bootstrap owner OTP sign-in");
    const sessionCookie = (signIn.headers.getSetCookie?.() ?? [])
      .map((cookie) => cookie.split(";", 1)[0])
      .find((cookie) => cookie.startsWith("better-auth.session_token="));
    assert(sessionCookie, "owner bootstrap did not issue a session cookie");
    ownerCookie = sessionCookie;
  }
  const apps = await request("/v1/apps", { cookie: ownerCookie });
  ok(apps, 200, "owner session");

  const email = `backend-smoke-${Date.now()}@pixel8.local`;
  ok(
    await json(`${base}/api/auth/email-otp/send-verification-otp`, {
      method: "POST",
      headers: {
        origin: "http://localhost:3000",
        "content-type": "application/json",
      },
      body: JSON.stringify({ email, type: "sign-in" }),
    }),
    200,
    "OTP request",
  );
  let otp;
  for (let attempt = 0; attempt < 20 && !otp; attempt++) {
    const inbox = await json(`${mailpit}/api/v1/messages`);
    const message = inbox.body.messages.find((item) =>
      item.To?.some((to) => to.Address === email),
    );
    otp = message?.Snippet?.match(/\b\d{6}\b/)?.[0];
    if (!otp) await new Promise((resolve) => setTimeout(resolve, 250));
  }
  assert(otp, "real OTP was not delivered to Mailpit");
  const signIn = await json(`${base}/api/auth/sign-in/email-otp`, {
    method: "POST",
    headers: {
      origin: "http://localhost:3000",
      "content-type": "application/json",
    },
    body: JSON.stringify({ email, otp, name: "Backend smoke tenant" }),
  });
  ok(signIn, 200, "second tenant OTP sign-in");
  const setCookies =
    signIn.headers.getSetCookie?.() ??
    [signIn.headers.get("set-cookie")].filter(Boolean);
  const otherCookie = setCookies
    .map((cookie) => cookie.split(";", 1)[0])
    .find((cookie) => cookie.startsWith("better-auth.session_token="));
  assert(otherCookie, "OTP sign-in did not issue a Better Auth session cookie");
  let throttledOtp = false;
  for (let attempt = 0; attempt < 12; attempt++) {
    const response = await json(
      `${base}/api/auth/email-otp/send-verification-otp`,
      {
        method: "POST",
        headers: {
          origin: "http://localhost:3000",
          "content-type": "application/json",
        },
        body: JSON.stringify({
          email: `otp-rate-${Date.now()}-${attempt}@pixel8.local`,
          type: "sign-in",
        }),
      },
    );
    if (response.status === 429) {
      throttledOtp = true;
      break;
    }
    ok(response, 200, "OTP rate-limit warm-up");
  }
  assert(
    throttledOtp,
    "OTP delivery endpoint must enforce its persisted rate limit",
  );

  const createdApp = await request("/v1/apps", {
    cookie: ownerCookie,
    method: "POST",
    body: { name: `Smoke ${Date.now()}` },
  });
  ok(createdApp, 200, "create app");
  const appId = createdApp.body.id;
  smokeAppId = appId;
  ok(
    await request(`/v1/apps/${appId}`, { cookie: otherCookie }),
    404,
    "tenant isolation for app",
  );

  const capabilities = {
    displayModes: [{ width: 1280, height: 720, refreshHz: 60 }],
    selectedMode: { width: 1280, height: 720, refreshHz: 60 },
    decoders: ["h264"],
    supports1080p: false,
    softwareVersion: "backend-smoke",
  };
  const pairing = await request("/v1/device/pairing", {
    method: "POST",
    body: { deviceId: `device-${randomUUID()}`, capabilities },
  });
  ok(pairing, 200, "start pairing");
  ok(
    await request(`/v1/device/pairing/${pairing.body.pairingId}/poll`, {
      method: "POST",
      body: { pollToken: pairing.body.pollToken },
    }),
    200,
    "pending pairing poll",
  );
  const claimed = await request("/v1/screens/pair", {
    cookie: ownerCookie,
    method: "POST",
    body: { code: pairing.body.code, name: "Smoke display" },
  });
  ok(claimed, 200, "claim screen");
  const screenId = claimed.body.id;
  const poll = await request(
    `/v1/device/pairing/${pairing.body.pairingId}/poll`,
    { method: "POST", body: { pollToken: pairing.body.pollToken } },
  );
  ok(poll, 200, "claimed pairing poll");
  assert.equal(poll.body.status, "claimed");
  assert(poll.body.deviceToken);
  const capabilitiesWithReorderedKeys = Object.fromEntries(
    Object.entries(capabilities).reverse(),
  );
  const firstCapabilities = await request("/v1/device/capabilities", {
    token: poll.body.deviceToken,
    method: "PUT",
    body: capabilitiesWithReorderedKeys,
  });
  ok(firstCapabilities, 200, "submit initial device capabilities");
  const repeatedCapabilities = await request("/v1/device/capabilities", {
    token: poll.body.deviceToken,
    method: "PUT",
    body: capabilitiesWithReorderedKeys,
  });
  ok(repeatedCapabilities, 200, "repeat unchanged device capabilities");
  assert.equal(
    repeatedCapabilities.body.desiredVersion,
    firstCapabilities.body.desiredVersion,
    "reordered JSONB keys must not advance desired version for unchanged capabilities",
  );
  assert.equal(
    (
      await request("/v1/screens/pair", {
        cookie: ownerCookie,
        method: "POST",
        body: { code: pairing.body.code, name: "Reuse attempt" },
      })
    ).status,
    404,
    "pairing codes cannot be reused",
  );
  const expiredPairing = await request("/v1/device/pairing", {
    method: "POST",
    body: { deviceId: `device-${randomUUID()}`, capabilities },
  });
  ok(expiredPairing, 200, "create pairing for expiry test");
  await prisma.pairing.update({
    where: { id: expiredPairing.body.pairingId },
    data: { expiresAt: new Date(Date.now() - 1000) },
  });
  const expiredPoll = await request(
    `/v1/device/pairing/${expiredPairing.body.pairingId}/poll`,
    {
      method: "POST",
      body: { pollToken: expiredPairing.body.pollToken },
    },
  );
  ok(expiredPoll, 200, "poll expired pairing");
  assert.equal(expiredPoll.body.status, "expired");
  assert.equal(
    (
      await request("/v1/screens/pair", {
        cookie: ownerCookie,
        method: "POST",
        body: { code: expiredPairing.body.code, name: "Expired pairing" },
      })
    ).status,
    404,
    "expired pairing cannot be claimed",
  );
  ok(
    await request(`/v1/screens/${screenId}`, { cookie: otherCookie }),
    404,
    "tenant isolation for screen",
  );

  const races = await Promise.all([
    request(`/v1/screens/${screenId}`, {
      cookie: ownerCookie,
      method: "PATCH",
      body: { expectedDesiredVersion: 1, volume: 41 },
    }),
    request(`/v1/screens/${screenId}`, {
      cookie: ownerCookie,
      method: "PATCH",
      body: { expectedDesiredVersion: 1, muted: false },
    }),
  ]);
  assert.equal(
    races.filter((response) => response.status === 200).length,
    1,
    "exactly one expected-version update wins",
  );
  assert.equal(
    races.filter((response) => response.status === 409).length,
    1,
    "losing expected-version update returns conflict",
  );
  const telemetrySample = {
    sampledAt: new Date().toISOString(),
    cpuPercent: 17,
    memoryUsedBytes: 64_000_000,
    memoryTotalBytes: 1_000_000_000,
    throttled: false,
    diskFreeBytes: 2_000_000_000,
    cacheBytes: 1_024,
    desiredVersion: 2,
    playingVersion: 1,
    droppedFrames: 0,
    softwareVersion: "backend-smoke",
    displayMode: { width: 1280, height: 720, refreshHz: 60 },
    decoder: "h264",
  };
  ok(
    await request("/v1/device/telemetry", {
      token: poll.body.deviceToken,
      method: "POST",
      body: { samples: [telemetrySample] },
    }),
    200,
    "submit screen telemetry",
  );
  const detailedScreen = await request(`/v1/screens/${screenId}`, {
    cookie: ownerCookie,
  });
  ok(detailedScreen, 200, "screen detail includes telemetry");
  assert.equal(detailedScreen.body.latestTelemetry.cpuPercent, 17);
  const screenList = await request("/v1/screens", { cookie: ownerCookie });
  ok(screenList, 200, "screen list includes telemetry");
  assert.equal(
    screenList.body.items.find((screen) => screen.id === screenId)
      .latestTelemetry.cpuPercent,
    17,
  );
  const telemetryMutation = await request(`/v1/screens/${screenId}`, {
    cookie: ownerCookie,
    method: "PATCH",
    body: { expectedDesiredVersion: 2, muted: true },
  });
  ok(telemetryMutation, 200, "screen mutation includes telemetry");
  assert.equal(telemetryMutation.body.latestTelemetry.cpuPercent, 17);
  const aggregateHour = new Date();
  aggregateHour.setUTCHours(aggregateHour.getUTCHours() - 3, 0, 0, 0);
  const aggregateCutoff = new Date(aggregateHour.getTime() + 2 * 60 * 60_000);
  const insertRetentionSample = async ({
    minute,
    cpu,
    memory,
    temperature,
    throttled,
    dropped,
  }) =>
    prisma.telemetry.create({
      data: {
        screenId,
        sampledAt: new Date(aggregateHour.getTime() + minute * 60_000),
        payload: {
          cpuPercent: cpu,
          memoryUsedBytes: memory,
          temperatureC: temperature,
          throttled,
          droppedFrames: dropped,
        },
        dedupeKey: randomUUID(),
      },
    });
  await insertRetentionSample({
    minute: 10,
    cpu: 20,
    memory: 1000,
    temperature: 40,
    throttled: false,
    dropped: 3,
  });
  await prisma.$transaction((tx) =>
    aggregateExpiredTelemetry(tx, aggregateCutoff),
  );
  await insertRetentionSample({
    minute: 30,
    cpu: 40,
    memory: 3000,
    temperature: 60,
    throttled: true,
    dropped: 9,
  });
  await prisma.$transaction((tx) =>
    aggregateExpiredTelemetry(tx, aggregateCutoff),
  );
  const mergedAggregate = await prisma.telemetryAggregate.findUnique({
    where: {
      screenId_hour: { screenId, hour: aggregateHour },
    },
  });
  assert.equal(
    mergedAggregate.sampleCount,
    2,
    "late telemetry merges into its hour",
  );
  assert.equal(mergedAggregate.cpuAverage, 30);
  assert.equal(Number(mergedAggregate.memoryAverageBytes), 2000);
  assert.equal(mergedAggregate.temperatureSampleCount, 2);
  assert.equal(mergedAggregate.temperatureAverageC, 50);
  assert.equal(mergedAggregate.throttledSamples, 1);
  assert.equal(mergedAggregate.droppedFramesMaximum, 9);

  if (process.env.SECONDARY_API_URL) {
    const require = createRequire(import.meta.url);
    const WebSocket = require("../node_modules/.pnpm/ws@8.22.0/node_modules/ws/index.js");
    const eventsUrl = new URL(
      "/v1/device/events",
      process.env.SECONDARY_API_URL,
    );
    eventsUrl.protocol = eventsUrl.protocol === "https:" ? "wss:" : "ws:";
    const socket = new WebSocket(eventsUrl, {
      headers: { authorization: `Bearer ${poll.body.deviceToken}` },
    });
    await new Promise((resolve, reject) => {
      const timeout = setTimeout(
        () => reject(new Error("WebSocket connect timed out")),
        5000,
      );
      socket.once("open", () => {
        clearTimeout(timeout);
        resolve();
      });
      socket.once("error", (error) => {
        clearTimeout(timeout);
        reject(error);
      });
    });
    const initialHint = await new Promise((resolve, reject) => {
      const timeout = setTimeout(
        () => reject(new Error("Initial desired-state hint timed out")),
        5000,
      );
      socket.once("message", (message) => {
        clearTimeout(timeout);
        resolve(JSON.parse(message.toString()));
      });
    });
    assert.deepEqual(initialHint, { type: "desired-state", version: 3 });
    const event = new Promise((resolve, reject) => {
      const timeout = setTimeout(
        () => reject(new Error("Cross-instance notification timed out")),
        5000,
      );
      socket.on("message", (message) => {
        const body = JSON.parse(message.toString());
        if (body.version <= initialHint.version) return;
        clearTimeout(timeout);
        socket.removeAllListeners("message");
        resolve(body);
      });
    });
    const updatedScreen = await request(`/v1/screens/${screenId}`, {
      cookie: ownerCookie,
      method: "PATCH",
      body: { expectedDesiredVersion: 3, volume: 49 },
    });
    ok(updatedScreen, 200, "cross-instance screen update");
    assert.deepEqual(await event, {
      type: "desired-state",
      version: updatedScreen.body.desiredVersion,
    });

    const listenerBackends = await prisma.$queryRaw`
      SELECT pid
      FROM pg_stat_activity
      WHERE datname = current_database()
        AND state = 'idle'
        AND query = 'LISTEN pixel8_screen'
        AND pid <> pg_backend_pid()
    `;
    assert(
      listenerBackends.length >= 2,
      `expected both API instances to hold a LISTEN connection, found ${listenerBackends.length}`,
    );
    const listenerPids = listenerBackends.map((row) => row.pid);
    await prisma.$queryRaw`
      SELECT pg_terminate_backend(pid) AS terminated
      FROM pg_stat_activity
      WHERE pid = ANY(${listenerPids}::int[])
    `;
    let recoveredListenerCount = 0;
    for (let attempt = 0; attempt < 30; attempt++) {
      await new Promise((resolve) => setTimeout(resolve, 250));
      const recoveredListeners = await prisma.$queryRaw`
        SELECT pid
        FROM pg_stat_activity
        WHERE datname = current_database()
          AND state = 'idle'
          AND query = 'LISTEN pixel8_screen'
          AND pid <> pg_backend_pid()
      `;
      recoveredListenerCount = recoveredListeners.length;
      if (recoveredListenerCount >= 2) break;
    }
    assert.equal(
      recoveredListenerCount,
      2,
      "both API instances must reconnect their PostgreSQL LISTEN clients",
    );
    ok(
      await request("/ready"),
      200,
      "primary API remains ready after LISTEN loss",
    );
    ok(
      await json(`${process.env.SECONDARY_API_URL}/ready`),
      200,
      "secondary API remains ready after LISTEN loss",
    );
    const afterReconnectEvent = new Promise((resolve, reject) => {
      const timeout = setTimeout(
        () => reject(new Error("Post-reconnect notification timed out")),
        5000,
      );
      socket.on("message", (message) => {
        const body = JSON.parse(message.toString());
        if (body.version <= updatedScreen.body.desiredVersion) return;
        clearTimeout(timeout);
        socket.removeAllListeners("message");
        resolve(body);
      });
    });
    const afterReconnectScreen = await request(`/v1/screens/${screenId}`, {
      cookie: ownerCookie,
      method: "PATCH",
      body: {
        expectedDesiredVersion: updatedScreen.body.desiredVersion,
        volume: 48,
      },
    });
    ok(afterReconnectScreen, 200, "screen update after LISTEN reconnect");
    assert.deepEqual(await afterReconnectEvent, {
      type: "desired-state",
      version: afterReconnectScreen.body.desiredVersion,
    });
    socket.close();
  }

  const png = Buffer.from(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC",
    "base64",
  );
  const startedUpload = await request(`/v1/apps/${appId}/uploads`, {
    cookie: ownerCookie,
    method: "POST",
    body: {
      name: "smoke.png",
      mimeType: "image/png",
      sizeBytes: png.byteLength,
    },
  });
  ok(startedUpload, 200, "start multipart upload");
  const uploadId = startedUpload.body.uploadId;
  const grants = await request(`/v1/uploads/${uploadId}/parts`, {
    cookie: ownerCookie,
    method: "POST",
    body: { partNumbers: [1] },
  });
  ok(grants, 200, "sign multipart part");
  const part = await fetch(grants.body.parts[0].url, {
    method: "PUT",
    body: png,
    headers: { "content-type": "image/png" },
  });
  assert.equal(part.status, 200, `S3 multipart upload: ${part.status}`);
  const completionBody = {
    parts: [{ partNumber: 1, etag: part.headers.get("etag") }],
  };
  const [complete, concurrentComplete] = await Promise.all([
    request(`/v1/uploads/${uploadId}/complete`, {
      cookie: ownerCookie,
      method: "POST",
      body: completionBody,
    }),
    request(`/v1/uploads/${uploadId}/complete`, {
      cookie: ownerCookie,
      method: "POST",
      body: completionBody,
    }),
  ]);
  ok(complete, 200, "complete multipart upload");
  ok(concurrentComplete, 200, "concurrent multipart completion retry");
  assert.equal(concurrentComplete.body.id, complete.body.id);
  const sequentialRetry = await request(`/v1/uploads/${uploadId}/complete`, {
    cookie: ownerCookie,
    method: "POST",
    body: completionBody,
  });
  ok(sequentialRetry, 200, "sequential multipart completion retry");
  assert.equal(sequentialRetry.body.id, complete.body.id);
  const assetOutboxRows = await prisma.job.findMany({
    where: { type: "process-asset" },
    select: { payload: true },
  });
  assert.equal(
    assetOutboxRows.filter((row) => row.payload.assetId === uploadId).length,
    1,
    "concurrent and sequential completion retries must create one asset outbox job",
  );
  let asset = complete.body;
  for (
    let attempt = 0;
    attempt < 120 && !["ready", "failed"].includes(asset.status);
    attempt++
  ) {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    asset = (
      await request(`/v1/apps/${appId}/assets`, { cookie: ownerCookie })
    ).body.items.find((item) => item.id === uploadId);
  }
  assert.equal(
    asset.status,
    "ready",
    `asset worker did not finish successfully: ${JSON.stringify(asset)}`,
  );
  const preview = await request(`/v1/assets/${uploadId}/preview`, {
    cookie: ownerCookie,
  });
  ok(preview, 200, "owner preview grant");
  assert.equal(preview.body.mimeType, "image/png");
  const heicBytes = await readFile(
    new URL("./fixtures/browser-test.heic", import.meta.url),
  );
  const heicAsset = await uploadMedia({
    appId,
    name: "synthetic.heic",
    mimeType: "image/heic",
    bytes: heicBytes,
  });
  assert(heicAsset.thumbnailUrl, "HEIC image must produce a thumbnail");
  const videoBytes = await readFile(
    new URL("./fixtures/browser-test.mp4", import.meta.url),
  );
  const videoAsset = await uploadMedia({
    appId,
    name: "synthetic.mp4",
    mimeType: "video/mp4",
    bytes: videoBytes,
  });
  assert(videoAsset.thumbnailUrl, "MP4 video must produce a thumbnail");
  const newCampaign = await request(`/v1/apps/${appId}/campaigns`, {
    cookie: ownerCookie,
    method: "POST",
    body: {
      name: "Smoke playlist",
      items: [{ assetId: uploadId, durationSeconds: 1, fit: "contain" }],
    },
  });
  ok(newCampaign, 200, "create campaign revision 1");
  let campaign;
  for (let attempt = 0; attempt < 180; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    campaign = (
      await request(`/v1/campaigns/${newCampaign.body.id}`, {
        cookie: ownerCookie,
      })
    ).body;
    if (campaign.currentRevision === 1 || campaign.status === "failed") break;
  }
  assert.equal(
    campaign.currentRevision,
    1,
    `campaign worker did not publish: ${JSON.stringify(campaign)}`,
  );

  const secondPairing = await request("/v1/device/pairing", {
    method: "POST",
    body: { deviceId: `device-${randomUUID()}`, capabilities },
  });
  ok(secondPairing, 200, "pair player for published campaign");
  const secondClaim = await request("/v1/screens/pair", {
    cookie: ownerCookie,
    method: "POST",
    body: { code: secondPairing.body.code, name: "Publication race screen" },
  });
  ok(secondClaim, 200, "claim publication race screen");
  const secondPoll = await request(
    `/v1/device/pairing/${secondPairing.body.pairingId}/poll`,
    { method: "POST", body: { pollToken: secondPairing.body.pollToken } },
  );
  ok(secondPoll, 200, "poll publication race screen");
  const secondScreenId = secondClaim.body.id;
  const assign = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
    method: "PATCH",
    body: { expectedDesiredVersion: 1, campaignId: newCampaign.body.id },
  });
  ok(assign, 200, "assign published campaign");
  const playManifest = await request("/v1/device/manifest", {
    token: secondPoll.body.deviceToken,
  });
  ok(playManifest, 200, "read transcoded campaign manifest");
  assert.equal(playManifest.body.items.length, 1);
  ok(
    await request("/v1/device/ack", {
      token: secondPoll.body.deviceToken,
      method: "POST",
      body: {
        version: assign.body.desiredVersion,
        status: "playing",
        currentItemId: playManifest.body.items[0].id,
      },
    }),
    200,
    "acknowledge playback",
  );
  const mismatchedFallback = await request("/v1/device/ack", {
    token: secondPoll.body.deviceToken,
    method: "POST",
    body: {
      version: assign.body.desiredVersion,
      status: "error",
      playingVersion: 1,
      currentItemId: playManifest.body.items[0].id,
      error: "fallback item must belong to its playback version",
    },
  });
  ok(
    mismatchedFallback,
    422,
    "reject an item from the wrong playback manifest",
  );
  ok(
    await request("/v1/device/ack", {
      token: secondPoll.body.deviceToken,
      method: "POST",
      body: {
        version: assign.body.desiredVersion,
        status: "error",
        playingVersion: null,
        error: "renderer stopped after a temporary decoder error",
      },
    }),
    200,
    "report a stopped renderer after playback failure",
  );
  const stoppedScreen = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  assert.equal(stoppedScreen.body.status, "error");
  assert.equal(stoppedScreen.body.playingVersion, null);
  const recoveredAck = await request("/v1/device/ack", {
    token: secondPoll.body.deviceToken,
    method: "POST",
    body: {
      version: assign.body.desiredVersion,
      status: "playing",
      currentItemId: playManifest.body.items[0].id,
    },
  });
  ok(recoveredAck, 200, "recover playback at the same manifest version");
  const recoveredScreen = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  ok(recoveredScreen, 200, "read recovered screen status");
  assert.equal(recoveredScreen.body.status, "playing");
  assert.equal(recoveredScreen.body.playingVersion, assign.body.desiredVersion);
  assert(
    recoveredScreen.body.error === null ||
      recoveredScreen.body.error === undefined,
    "a successful same-version ACK must clear a prior renderer error",
  );
  const stalePlaybackError = await request("/v1/device/ack", {
    token: secondPoll.body.deviceToken,
    method: "POST",
    body: {
      version: 1,
      status: "error",
      playingVersion: null,
      error: "delayed error from an older generation",
    },
  });
  ok(stalePlaybackError, 200, "accept stale error acknowledgement as ignored");
  assert.equal(stalePlaybackError.body.stale, true);
  const stillRecovered = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  assert.equal(stillRecovered.body.status, "playing");
  assert.equal(stillRecovered.body.playingVersion, assign.body.desiredVersion);
  const delayedDownload = await request("/v1/device/ack", {
    token: secondPoll.body.deviceToken,
    method: "POST",
    body: { version: assign.body.desiredVersion, status: "downloading" },
  });
  ok(delayedDownload, 200, "reject delayed download status after playback");
  assert.equal(delayedDownload.body.stale, true);

  const edit = request(`/v1/campaigns/${newCampaign.body.id}`, {
    cookie: ownerCookie,
    method: "PUT",
    body: {
      expectedRevision: 1,
      name: "Smoke playlist next",
      items: [{ assetId: uploadId, durationSeconds: 1, fit: "contain" }],
    },
  });
  const unassign = request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
    method: "PATCH",
    body: {
      expectedDesiredVersion: assign.body.desiredVersion,
      campaignId: null,
    },
  });
  const [candidate, unassignResult] = await Promise.all([edit, unassign]);
  ok(candidate, 200, "create campaign revision 2");
  assert(
    [200, 409].includes(unassignResult.status),
    `unexpected concurrent unassignment response ${unassignResult.status}`,
  );
  if (unassignResult.status === 409) {
    const currentScreen = (
      await request(`/v1/screens/${secondScreenId}`, { cookie: ownerCookie })
    ).body;
    if (currentScreen.campaignId)
      ok(
        await request(`/v1/screens/${secondScreenId}`, {
          cookie: ownerCookie,
          method: "PATCH",
          body: {
            expectedDesiredVersion: currentScreen.desiredVersion,
            campaignId: null,
          },
        }),
        200,
        "retry unassignment after publication CAS",
      );
  }
  for (let attempt = 0; attempt < 120; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    campaign = (
      await request(`/v1/campaigns/${newCampaign.body.id}`, {
        cookie: ownerCookie,
      })
    ).body;
    if (campaign.currentRevision === 2 || campaign.status === "failed") break;
  }
  assert.equal(
    campaign.currentRevision,
    2,
    `campaign revision 2 not published: ${JSON.stringify(campaign)}`,
  );
  const detached = (
    await request(`/v1/screens/${secondScreenId}`, { cookie: ownerCookie })
  ).body;
  assert.equal(
    detached.campaignId,
    null,
    "worker publication must not reassign an unassigned screen",
  );

  const currentRaceScreen = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  ok(currentRaceScreen, 200, "read screen before publication/settings race");
  const reassignForSettingsRace = await request(
    `/v1/screens/${secondScreenId}`,
    {
      cookie: ownerCookie,
      method: "PATCH",
      body: {
        expectedDesiredVersion: currentRaceScreen.body.desiredVersion,
        campaignId: newCampaign.body.id,
      },
    },
  );
  ok(reassignForSettingsRace, 200, "reassign screen for settings race");
  const revision3Edit = request(`/v1/campaigns/${newCampaign.body.id}`, {
    cookie: ownerCookie,
    method: "PUT",
    body: {
      expectedRevision: 2,
      name: "Smoke playlist revision three",
      items: [{ assetId: uploadId, durationSeconds: 1, fit: "contain" }],
    },
  });
  let screenSettings = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
    method: "PATCH",
    body: {
      expectedDesiredVersion: reassignForSettingsRace.body.desiredVersion,
      orientation: 90,
    },
  });
  const revision3Result = await revision3Edit;
  ok(revision3Result, 200, "create revision during screen settings update");
  assert(
    [200, 409].includes(screenSettings.status),
    `unexpected screen settings race response ${screenSettings.status}`,
  );
  for (let attempt = 0; attempt < 120; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 250));
    campaign = (
      await request(`/v1/campaigns/${newCampaign.body.id}`, {
        cookie: ownerCookie,
      })
    ).body;
    if (campaign.currentRevision === 3 || campaign.status === "failed") break;
  }
  assert.equal(campaign.currentRevision, 3, "revision 3 is published");
  if (screenSettings.status === 409) {
    const latest = await request(`/v1/screens/${secondScreenId}`, {
      cookie: ownerCookie,
    });
    screenSettings = await request(`/v1/screens/${secondScreenId}`, {
      cookie: ownerCookie,
      method: "PATCH",
      body: {
        expectedDesiredVersion: latest.body.desiredVersion,
        orientation: 90,
      },
    });
  }
  ok(screenSettings, 200, "finish screen settings update after publication");
  const revision3LatestScreen = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  ok(revision3LatestScreen, 200, "read latest settings race screen");
  const revision3State = await prisma.desiredState.findUnique({
    where: {
      screenId_version: {
        screenId: secondScreenId,
        version: revision3LatestScreen.body.desiredVersion,
      },
    },
  });
  assert.equal(
    revision3State?.campaignRevision,
    3,
    "settings update must capture the latest published campaign revision",
  );

  const revision4Edit = request(`/v1/campaigns/${newCampaign.body.id}`, {
    cookie: ownerCookie,
    method: "PUT",
    body: {
      expectedRevision: 3,
      name: "Smoke playlist revision four",
      items: [{ assetId: uploadId, durationSeconds: 1, fit: "cover" }],
    },
  });
  const capabilityChange = request("/v1/device/capabilities", {
    token: secondPoll.body.deviceToken,
    method: "PUT",
    body: { ...capabilities, softwareVersion: "backend-smoke-updated" },
  });
  const [revision4Result, capabilityResult] = await Promise.all([
    revision4Edit,
    capabilityChange,
  ]);
  ok(revision4Result, 200, "create revision during capability update");
  ok(capabilityResult, 200, "update capabilities during campaign publication");
  for (let attempt = 0; attempt < 120; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 250));
    campaign = (
      await request(`/v1/campaigns/${newCampaign.body.id}`, {
        cookie: ownerCookie,
      })
    ).body;
    if (campaign.currentRevision === 4 || campaign.status === "failed") break;
  }
  assert.equal(campaign.currentRevision, 4, "revision 4 is published");
  const latestRaceScreen = await request(`/v1/screens/${secondScreenId}`, {
    cookie: ownerCookie,
  });
  const revision4State = await prisma.desiredState.findUnique({
    where: {
      screenId_version: {
        screenId: secondScreenId,
        version: latestRaceScreen.body.desiredVersion,
      },
    },
  });
  assert.equal(
    revision4State?.campaignRevision,
    4,
    "capability update must capture the latest published campaign revision",
  );

  ok(
    await request(`/v1/screens/${secondScreenId}`, {
      cookie: ownerCookie,
      method: "DELETE",
    }),
    200,
    "delete publication race screen",
  );

  const removed = await request(`/v1/screens/${screenId}`, {
    cookie: ownerCookie,
    method: "DELETE",
  });
  ok(removed, 200, "delete screen");
  ok(
    await request("/v1/device/manifest", { token: poll.body.deviceToken }),
    401,
    "deleted screen token is revoked",
  );
  const ownerSession = await json(`${base}/api/auth/get-session`, {
    headers: { cookie: ownerCookie },
  });
  ok(ownerSession, 200, "owner session lookup");
  const ownerId = ownerSession.body.user.id;
  const records = Array.from({ length: 100 }, (_, index) => {
    const id = randomUUID();
    const token = randomBytes(32).toString("base64url");
    simulatorIds.push(id);
    return {
      id,
      token,
      data: {
        id,
        ownerId,
        name: `backend-smoke-${id}`,
        deviceId: `simulator-${id}`,
        deviceTokenHash: createHash("sha256").update(token).digest("hex"),
        muted: true,
        volume: 50,
        desiredVersion: 1,
        status: "offline",
        createdAt: new Date(),
      },
    };
  });
  await prisma.$transaction([
    prisma.screen.createMany({ data: records.map((record) => record.data) }),
    prisma.desiredState.createMany({
      data: records.map(({ id }) => ({
        screenId: id,
        version: 1,
        campaignId: null,
        campaignRevision: null,
        orientation: 0,
        muted: true,
        volume: 50,
      })),
    }),
    prisma.manifestRecord.createMany({
      data: records.map(({ id }) => ({
        screenId: id,
        version: 1,
        body: {
          schemaVersion: 1,
          screenId: id,
          version: 1,
          profile: "720p30-v1",
          orientation: 0,
          muted: true,
          volume: 50,
          items: [],
        },
      })),
    }),
  ]);
  const assignStartedAt = performance.now();
  const assignments = await Promise.all(
    records.map((record) =>
      request(`/v1/screens/${record.id}`, {
        cookie: ownerCookie,
        method: "PATCH",
        body: { expectedDesiredVersion: 1, campaignId: newCampaign.body.id },
      }),
    ),
  );
  assert(
    assignments.every((response) => response.status === 200),
    `100-screen campaign assignment failed: ${assignments.filter((response) => response.status !== 200).length} failures`,
  );
  const endpointFor = (index) =>
    process.env.SECONDARY_API_URL && index % 2 === 1
      ? process.env.SECONDARY_API_URL
      : base;
  const initialSockets = records.map((record, index) =>
    connectDeviceSocket(record, endpointFor(index)),
  );
  await Promise.all(initialSockets.map((connection) => connection.opened));
  const initialSocketVersions = await Promise.all(
    initialSockets.map((connection) => connection.waitForVersion(2)),
  );
  assert(
    initialSocketVersions.every((version) => version === 2),
    "all 100 device sockets must receive the assigned version hint",
  );
  await Promise.all(initialSockets.map((connection) => connection.close()));
  const reconnectStartedAt = performance.now();
  const reconnectedSockets = records.map((record, index) =>
    connectDeviceSocket(record, endpointFor(index)),
  );
  await Promise.all(reconnectedSockets.map((connection) => connection.opened));
  const revision5StartedAt = performance.now();
  ok(
    await request(`/v1/campaigns/${newCampaign.body.id}`, {
      cookie: ownerCookie,
      method: "PUT",
      body: {
        expectedRevision: 4,
        name: "100-screen published campaign",
        items: [
          { assetId: uploadId, durationSeconds: 1, fit: "contain" },
          { assetId: heicAsset.id, durationSeconds: 2, fit: "contain" },
          { assetId: videoAsset.id, durationSeconds: 5, fit: "cover" },
        ],
      },
    }),
    200,
    "publish campaign to 100 simulated screens",
  );
  const reconnectHints = await Promise.all(
    reconnectedSockets.map((connection) => connection.waitForVersion(3)),
  );
  assert(
    reconnectHints.every((version) => version === 3),
    "all 100 reconnecting devices must reconcile the newly published version",
  );
  await Promise.all(reconnectedSockets.map((connection) => connection.close()));
  const reconnectPublicationDurationMs = Math.round(
    performance.now() - reconnectStartedAt,
  );
  for (let attempt = 0; attempt < 120; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 250));
    campaign = (
      await request(`/v1/campaigns/${newCampaign.body.id}`, {
        cookie: ownerCookie,
      })
    ).body;
    if (campaign.currentRevision === 5 || campaign.status === "failed") break;
  }
  assert.equal(
    campaign.currentRevision,
    5,
    "revision 5 publishes to load cohort",
  );
  const probedVideoRendition = await prisma.rendition.findFirst({
    where: {
      assetId: videoAsset.id,
      profile: "720p30-v1",
      orientation: 0,
    },
  });
  assert(
    probedVideoRendition && probedVideoRendition.durationSeconds >= 1.9,
    "MP4 rendition duration must come from the complete media probe",
  );
  const publicationDurationMs = Math.round(
    performance.now() - revision5StartedAt,
  );
  const publishedScreens = await prisma.screen.findMany({
    where: { id: { in: simulatorIds } },
    select: { id: true, desiredVersion: true, campaignId: true },
  });
  assert.equal(publishedScreens.length, 100);
  assert(
    publishedScreens.every(
      (screen) =>
        screen.desiredVersion === 3 &&
        screen.campaignId === newCampaign.body.id,
    ),
    "campaign publication advances all assigned screens",
  );
  const publishedStates = await prisma.desiredState.findMany({
    where: { screenId: { in: simulatorIds }, version: 3 },
  });
  assert.equal(publishedStates.length, 100);
  assert(
    publishedStates.every((state) => state.campaignRevision === 5),
    "all 100 desired states capture the newly published revision",
  );
  let cursor = 0;
  const loadStartedAt = performance.now();
  const workers = Array.from({ length: 20 }, async () => {
    while (cursor < records.length) {
      const record = records[cursor++];
      const manifest = await request("/v1/device/manifest", {
        token: record.token,
      });
      ok(manifest, 200, "simulated device manifest");
      assert.equal(manifest.body.items.length, 3);
      const ack = await request("/v1/device/ack", {
        token: record.token,
        method: "POST",
        body: {
          version: 3,
          status: "playing",
          currentItemId: manifest.body.items[0].id,
        },
      });
      ok(ack, 200, "simulated playback acknowledgement");
    }
  });
  await Promise.all(workers);
  const beforeFailure = await prisma.asset.findUnique({
    where: { id: uploadId },
    select: { sourceKey: true },
  });
  await prisma.asset.update({
    where: { id: uploadId },
    data: { sourceKey: `missing/${randomUUID()}` },
  });
  const failedCandidate = await request(
    `/v1/campaigns/${newCampaign.body.id}`,
    {
      cookie: ownerCookie,
      method: "PUT",
      body: {
        expectedRevision: 5,
        name: "Broken next",
        items: [{ assetId: uploadId, durationSeconds: 1, fit: "cover" }],
      },
    },
  );
  ok(failedCandidate, 200, "create revision for failure-retention test");
  try {
    for (let attempt = 0; attempt < 30; attempt++) {
      await new Promise((resolve) => setTimeout(resolve, 500));
      campaign = (
        await request(`/v1/campaigns/${newCampaign.body.id}`, {
          cookie: ownerCookie,
        })
      ).body;
      if (campaign.status === "failed") break;
    }
  } finally {
    await prisma.asset.update({
      where: { id: uploadId },
      data: { sourceKey: beforeFailure.sourceKey },
    });
  }
  assert.equal(
    campaign.status,
    "failed",
    "failed candidate is reported as failed",
  );
  assert.equal(
    campaign.currentRevision,
    5,
    "failed candidate does not replace the last published revision",
  );
  await prisma.screen.deleteMany({ where: { id: { in: simulatorIds } } });
  simulatorIds = [];
  ok(
    await request(`/v1/apps/${appId}`, {
      cookie: ownerCookie,
      method: "DELETE",
    }),
    200,
    "soft-delete app",
  );
  ok(
    await request(`/v1/apps/${appId}`, { cookie: ownerCookie }),
    404,
    "soft-deleted app is hidden",
  );
  smokeAppId = undefined;
  const loadDurationMs = Math.round(performance.now() - loadStartedAt);
  console.log(
    `Backend smoke passed: OTP throttling, tenant isolation, pairing claim/reuse/expiry/revocation, CORS, CAS and truthful playback recovery, PNG/HEIC/MP4 processing, settings/capability publication races, 100 WebSocket reconnects, and publication on 100 screens. Assignment took ${Math.round(performance.now() - assignStartedAt) - publicationDurationMs} ms; reconnect plus publication hints took ${reconnectPublicationDurationMs} ms; 100-screen publication took ${publicationDurationMs} ms; 200 manifest/ack requests took ${loadDurationMs} ms at concurrency 20.`,
  );
} finally {
  if (simulatorIds.length)
    await prisma.screen
      .deleteMany({ where: { id: { in: simulatorIds } } })
      .catch(() => {});
  if (smokeAppId && ownerCookie)
    await request(`/v1/apps/${smokeAppId}`, {
      cookie: ownerCookie,
      method: "DELETE",
    }).catch(() => {});
  await prisma.$disconnect();
}
