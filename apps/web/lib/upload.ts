import { api } from './api';

type UploadSession = { uploadId: string; appId: string; name: string; size: number; lastModified: number; mimeType: string; partSize: number; createdAt: number; etags: Record<number, string> };
const keyFor = (file: File, appId: string) => `pixel8-upload:${appId}:${file.name}:${file.size}:${file.lastModified}`;

export async function uploadFile(appId: string, file: File, onProgress: (value: number) => void, signal: AbortSignal): Promise<void> {
  const key = keyFor(file, appId);
  let session = readSession(key);
  if (!session) {
    const created = await sessionRequest<{ uploadId: string; partSizeBytes: number }>(`/v1/apps/${appId}/uploads`, {
      method: 'POST', body: JSON.stringify({ name: file.name, mimeType: file.type || mimeForName(file.name), sizeBytes: file.size }),
    });
    session = { uploadId: created.uploadId, appId, name: file.name, size: file.size, lastModified: file.lastModified, mimeType: file.type || mimeForName(file.name), partSize: created.partSizeBytes, createdAt: Date.now(), etags: {} };
    writeSession(key, session);
  }
  const count = Math.ceil(file.size / session.partSize);
  const missing = Array.from({ length: count }, (_, index) => index + 1).filter((number) => !session!.etags[number]);
  onProgress(Object.keys(session.etags).length / count);
  if (missing.length) {
    const signed = await sessionRequest<{ parts: Array<{ partNumber: number; url: string }> }>(`/v1/uploads/${session.uploadId}/parts`, {
      method: 'POST', body: JSON.stringify({ partNumbers: missing }),
    }, key);
    for (const part of signed.parts) {
      if (signal.aborted) throw new DOMException('Upload aborted', 'AbortError');
      const start = (part.partNumber - 1) * session.partSize;
      let response = await fetch(part.url, { method: 'PUT', body: file.slice(start, Math.min(start + session.partSize, file.size)), signal });
      if (response.status === 401 || response.status === 403) {
        const renewed = await sessionRequest<{ parts: Array<{ partNumber: number; url: string }> }>(`/v1/uploads/${session.uploadId}/parts`, {
          method: 'POST', body: JSON.stringify({ partNumbers: [part.partNumber] }),
        }, key);
        response = await fetch(renewed.parts[0].url, { method: 'PUT', body: file.slice(start, Math.min(start + session.partSize, file.size)), signal });
      }
      if (!response.ok) throw new Error(`Storage rejected part ${part.partNumber} (${response.status}).`);
      const etag = response.headers.get('ETag');
      if (!etag) throw new Error(`Storage did not return an ETag for part ${part.partNumber}.`);
      session.etags[part.partNumber] = etag;
      writeSession(key, session);
      onProgress(Object.keys(session.etags).length / count);
    }
  }
  if (signal.aborted) throw new DOMException('Upload aborted', 'AbortError');
  await sessionRequest(`/v1/uploads/${session.uploadId}/complete`, {
    method: 'POST', body: JSON.stringify({ parts: Array.from({ length: count }, (_, index) => ({ partNumber: index + 1, etag: session!.etags[index + 1] })) }),
  }, key);
  localStorage.removeItem(key);
}

export async function abortUpload(appId: string, file: File): Promise<void> {
  const key = keyFor(file, appId);
  const session = readSession(key);
  if (session) await api(`/v1/uploads/${session.uploadId}`, { method: 'DELETE' });
  localStorage.removeItem(key);
}

function readSession(key: string): UploadSession | undefined {
  const raw = localStorage.getItem(key);
  if (!raw) return;
  try {
    const session = JSON.parse(raw) as UploadSession;
    if (!session.createdAt || Date.now() - session.createdAt > 23 * 60 * 60 * 1000) { localStorage.removeItem(key); return; }
    return session;
  } catch { localStorage.removeItem(key); return; }
}
function writeSession(key: string, value: UploadSession): void { localStorage.setItem(key, JSON.stringify(value)); }
async function sessionRequest<T = unknown>(path: string, init?: RequestInit, key?: string): Promise<T> {
  try { return await api<T>(path, init); }
  catch (error) { if (key && [404,410].includes((error as {status?:number}).status??0)) localStorage.removeItem(key); throw error; }
}

export function mimeForName(name: string): string {
  const extension = name.split('.').pop()?.toLowerCase();
  return ({jpg:'image/jpeg',jpeg:'image/jpeg',png:'image/png',webp:'image/webp',gif:'image/gif',bmp:'image/bmp',heic:'image/heic',heif:'image/heif',avif:'image/avif',mp4:'video/mp4',m4v:'video/x-m4v',mov:'video/quicktime',webm:'video/webm',mkv:'video/x-matroska',avi:'video/x-msvideo'} as Record<string,string>)[extension??''] ?? 'application/octet-stream';
}
