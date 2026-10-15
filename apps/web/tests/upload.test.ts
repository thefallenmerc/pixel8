import { describe, expect, it } from 'vitest';
import { mimeForName } from '../lib/upload';

describe('upload MIME detection', () => {
  it.each([
    ['poster.JPG', 'image/jpeg'],
    ['capture.HEIC', 'image/heic'],
    ['loop.MOV', 'video/quicktime'],
    ['clip.webm', 'video/webm'],
    ['unknown.bin', 'application/octet-stream'],
  ])('maps %s to %s when browsers omit file.type', (name, expected) => {
    expect(mimeForName(name)).toBe(expected);
  });
});
