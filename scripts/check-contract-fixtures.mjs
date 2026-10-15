import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import {
  manifestSchema,
  telemetrySampleSchema,
  playbackAckSchema,
} from "../packages/contracts/dist/index.js";

const json = async (name) =>
  JSON.parse(
    await readFile(
      new URL(`../packages/contracts/fixtures/${name}`, import.meta.url),
      "utf8",
    ),
  );
const manifest = manifestSchema.parse(await json("manifest.json"));
const emptyManifest = manifestSchema.parse(await json("manifest-empty.json"));
telemetrySampleSchema.parse(await json("telemetry.json"));
playbackAckSchema.parse(await json("playback-ack-fallback.json"));
playbackAckSchema.parse(await json("playback-ack-stopped.json"));
assert.equal(
  manifest.items.length > 0,
  true,
  "manifest fixture must cover media items",
);
assert.equal(
  emptyManifest.items.length,
  0,
  "empty manifest fixture must contain no media",
);
assert.equal(
  playbackAckSchema.safeParse({
    version: emptyManifest.version,
    status: "idle",
  }).success,
  true,
);
assert.equal(
  playbackAckSchema.safeParse({ version: manifest.version, status: "playing" })
    .success,
  true,
);
console.log(
  "Shared manifest, empty-manifest, telemetry, and playback-ack fixtures are valid.",
);
