const required = (name: string) => {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required environment variable ${name}`);
  return value;
};
export const config = {
  port: Number(process.env.PORT ?? 3001),
  databaseUrl: required("DATABASE_URL"),
  authSecret: required("BETTER_AUTH_SECRET"),
  publicUrl: process.env.API_BASE_URL ?? "http://localhost:3001",
  tokenEncryptionKey: required("TOKEN_ENCRYPTION_KEY"),
  bucket: process.env.S3_BUCKET ?? "pixel8",
  s3Endpoint: process.env.S3_ENDPOINT ?? "http://localhost:19000",
  s3PublicEndpoint:
    process.env.S3_PUBLIC_ENDPOINT ??
    process.env.S3_ENDPOINT ??
    "http://localhost:19000",
  s3Region: process.env.S3_REGION ?? "auto",
  s3AccessKey:
    process.env.S3_ACCESS_KEY_ID ?? process.env.S3_ACCESS_KEY ?? "minioadmin",
  s3SecretKey:
    process.env.S3_SECRET_ACCESS_KEY ??
    process.env.S3_SECRET_KEY ??
    "minioadmin",
  isProduction: process.env.NODE_ENV === "production",
  maxUploadBytes: Number(process.env.MAX_UPLOAD_BYTES ?? 20_000_000_000),
};
