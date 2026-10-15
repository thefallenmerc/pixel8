export interface Pixel8Options {
  baseUrl: string;
  token?: string;
  fetch?: typeof fetch;
}
export class Pixel8Client {
  private readonly baseUrl: string;
  private readonly token?: string;
  private readonly request: typeof fetch;
  constructor(options: Pixel8Options) {
    this.baseUrl = options.baseUrl.replace(/\/$/, "");
    this.token = options.token;
    this.request = (options.fetch ?? globalThis.fetch).bind(globalThis);
  }
  async call<T>(path: string, init: RequestInit = {}): Promise<T> {
    const headers = new Headers(init.headers);
    if (this.token) headers.set("Authorization", `Bearer ${this.token}`);
    if (init.body && !headers.has("Content-Type"))
      headers.set("Content-Type", "application/json");
    const response = await this.request(`${this.baseUrl}${path}`, {
      ...init,
      headers,
      credentials: "include",
    });
    if (response.status === 204) return undefined as T;
    const body = await response.json();
    if (!response.ok)
      throw Object.assign(
        new Error(
          body?.error?.message ?? `Pixel8 request failed (${response.status})`,
        ),
        {
          status: response.status,
          code: body?.error?.code,
          details: body?.error?.details,
        },
      );
    return body as T;
  }
  listApps<T>() {
    return this.call<T>("/v1/apps");
  }
  createApp<T>(body: unknown) {
    return this.call<T>("/v1/apps", {
      method: "POST",
      body: JSON.stringify(body),
    });
  }
  listScreens<T>() {
    return this.call<T>("/v1/screens");
  }
  getManifest<T>() {
    return this.call<T | undefined>("/v1/device/manifest");
  }
}
