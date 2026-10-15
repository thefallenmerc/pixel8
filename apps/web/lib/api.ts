import { Pixel8Client } from '@pixel8/sdk-ts';

export const API_URL = (process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001').replace(/\/$/, '');
export const pixel8 = new Pixel8Client({ baseUrl: API_URL });

export type AppRecord = { id: string; name: string; description: string | null; createdAt: string };
export type Asset = { id: string; appId: string; name: string; mimeType: string; sizeBytes: number; status: 'uploading'|'processing'|'ready'|'failed'; thumbnailUrl?: string; error?: string };
export type CampaignItem = { assetId: string; durationSeconds: number; fit: 'contain'|'cover' };
export type Campaign = { id: string; appId: string; name: string; description: string; revision: number; currentRevision?: number; status: 'preparing'|'ready'|'failed'; items: CampaignItem[]; error?: string };
export type Telemetry = { sampledAt: string; cpuPercent: number; memoryUsedBytes: number; memoryTotalBytes: number; temperatureC?: number; droppedFrames: number; diskFreeBytes: number; cacheBytes: number; currentItemId?: string; error?: string };
export type Screen = { id: string; name: string; campaignId: string|null; orientation: 0|90|180|270; muted: boolean; volume: number; desiredVersion: number; playingVersion: number|null; status: 'offline'|'preparing'|'ready'|'downloading'|'playing'|'error'; lastSeenAt?: string; error?: string; capabilities?: { supports1080p?: boolean; softwareVersion?: string }; latestTelemetry?: Telemetry };

export async function api<T>(path: string, init?: RequestInit): Promise<T> {
  return pixel8.call<T>(path, init);
}

export function requestBody(value: unknown): RequestInit {
  return { method: 'POST', body: JSON.stringify(value) };
}
