import { z } from "zod";

export const uuid = z.string().uuid();
export const id = uuid;
export const timestamp = z.string().datetime({ offset: true });
export const errorSchema = z.object({
  error: z.object({
    code: z.string(),
    message: z.string(),
    details: z.unknown().optional(),
  }),
});
export const appSchema = z.object({
  id,
  name: z.string(),
  description: z.string().nullable(),
  createdAt: timestamp,
});
export const assetSchema = z.object({
  id,
  appId: id,
  name: z.string(),
  mimeType: z.string(),
  sizeBytes: z.number().int().nonnegative(),
  status: z.enum(["uploading", "processing", "ready", "failed"]),
  thumbnailUrl: z.string().url().optional(),
  error: z.string().optional(),
});
export const campaignItemSchema = z.object({
  assetId: id,
  durationSeconds: z.number().int().min(1).max(86400),
  fit: z.enum(["contain", "cover"]),
});
export const campaignSchema = z.object({
  id,
  appId: id,
  name: z.string(),
  description: z.string().nullable(),
  revision: z.number().int().positive(),
  currentRevision: z.number().int().positive().nullable(),
  status: z.enum(["preparing", "ready", "failed"]),
  items: z.array(campaignItemSchema),
  error: z.string().optional(),
});
export const displayModeSchema = z.object({
  width: z.number().int().positive(),
  height: z.number().int().positive(),
  refreshHz: z.number().positive(),
});
export const capabilitiesSchema = z.object({
  displayModes: z.array(displayModeSchema),
  selectedMode: displayModeSchema,
  decoders: z.array(z.string()),
  supports1080p: z.boolean(),
  softwareVersion: z.string(),
});
export const screenSchema = z.object({
  id,
  name: z.string(),
  campaignId: id.nullable(),
  orientation: z.union([
    z.literal(0),
    z.literal(90),
    z.literal(180),
    z.literal(270),
  ]),
  muted: z.boolean(),
  volume: z.number().int().min(0).max(100),
  desiredVersion: z.number().int().positive(),
  playingVersion: z.number().int().positive().nullable(),
  status: z.enum([
    "offline",
    "preparing",
    "ready",
    "downloading",
    "playing",
    "error",
  ]),
  lastSeenAt: timestamp.optional(),
  error: z.string().optional(),
  capabilities: capabilitiesSchema.optional(),
  latestTelemetry: z.record(z.unknown()).optional(),
});
export const manifestSchema = z.object({
  schemaVersion: z.literal(1),
  screenId: id,
  version: z.number().int().positive(),
  profile: z.enum(["720p30-v1", "1080p30-v1"]),
  orientation: z.union([
    z.literal(0),
    z.literal(90),
    z.literal(180),
    z.literal(270),
  ]),
  muted: z.boolean(),
  volume: z.number().int().min(0).max(100),
  items: z.array(
    z.object({
      id,
      assetId: id,
      renditionId: id,
      sha256: z.string().regex(/^[a-f0-9]{64}$/),
      sizeBytes: z.number().int().nonnegative(),
      durationMs: z.number().int().positive(),
    }),
  ),
});
export const createAppSchema = z.object({
  name: z.string().trim().min(1).max(120),
  description: z.string().max(2000).nullable().optional(),
});
export const patchAppSchema = createAppSchema.partial();
export const createCampaignSchema = z.object({
  name: z.string().trim().min(1).max(120),
  description: z.string().max(2000).nullable().optional(),
  items: z.array(campaignItemSchema),
});
export const updateCampaignSchema = createCampaignSchema.extend({
  expectedRevision: z.number().int().positive(),
});
export const uploadCreateSchema = z.object({
  name: z.string().trim().min(1).max(255),
  mimeType: z.string().min(1).max(255),
  sizeBytes: z.number().int().positive().max(20_000_000_000),
});
export const pairingRequestSchema = z.object({
  deviceId: z.string().min(1).max(255),
  capabilities: capabilitiesSchema,
});
export const screenPatchSchema = z.object({
  expectedDesiredVersion: z.number().int().positive(),
  name: z.string().trim().min(1).max(120).optional(),
  campaignId: id.nullable().optional(),
  orientation: z
    .union([z.literal(0), z.literal(90), z.literal(180), z.literal(270)])
    .optional(),
  muted: z.boolean().optional(),
  volume: z.number().int().min(0).max(100).optional(),
});
export const telemetrySampleSchema = z.object({
  sampledAt: timestamp,
  cpuPercent: z.number().min(0).max(100),
  memoryUsedBytes: z.number().int().nonnegative(),
  memoryTotalBytes: z.number().int().positive(),
  temperatureC: z.number().optional(),
  throttled: z.boolean(),
  diskFreeBytes: z.number().int().nonnegative(),
  cacheBytes: z.number().int().nonnegative(),
  currentItemId: id.optional(),
  desiredVersion: z.number().int().positive(),
  playingVersion: z.number().int().positive().optional(),
  droppedFrames: z.number().int().nonnegative(),
  softwareVersion: z.string(),
  displayMode: displayModeSchema,
  decoder: z.string(),
  error: z.string().optional(),
});
export const playbackAckSchema = z.object({
  version: z.number().int().positive(),
  status: z.enum(["downloading", "playing", "idle", "error"]),
  currentItemId: id.optional(),
  playingVersion: z.number().int().positive().nullable().optional(),
  error: z.string().max(2000).optional(),
});
export type App = z.infer<typeof appSchema>;
export type Asset = z.infer<typeof assetSchema>;
export type Campaign = z.infer<typeof campaignSchema>;
export type Screen = z.infer<typeof screenSchema>;
export type Capabilities = z.infer<typeof capabilitiesSchema>;
export type Manifest = z.infer<typeof manifestSchema>;
