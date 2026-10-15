# Managed deployment

The repository includes a Render blueprint for the API, Next.js dashboard, PostgreSQL and a separate media worker. Media originals, thumbnails and renditions live in a private Cloudflare R2 bucket. Resend delivers production email codes. The Docker Compose services are development-only.

## Configure services

1. Create a private R2 bucket and an access key scoped to that bucket. Set `S3_ENDPOINT` to the account's R2 S3 endpoint, `S3_REGION=auto`, `S3_FORCE_PATH_STYLE=false`, bucket name and credentials. Do not enable public bucket access.
2. Configure bucket CORS for the exact HTTPS dashboard origin: allow `GET`, `PUT`, `HEAD`, `POST`, `DELETE`; allow request headers; expose `ETag`. The browser reads each multipart part's ETag before completing the upload.
3. Verify a sending domain in Resend. Set `RESEND_API_KEY` and `EMAIL_FROM` to a verified sender.
4. Create the services from `render.yaml`. Select paid, continuously running service/database plans appropriate to the workload. A media worker needs sufficient RAM, temporary disk and CPU for FFmpeg. Start with one concurrent encode and increase only after observing memory and queue latency.
5. Assign same-site HTTPS custom domains, for example `api.example.com` and `screens.example.com`. Separate `*.onrender.com` service addresses are cross-site and will not support the dashboard's SameSite session cookies reliably. Set `API_BASE_URL` to the API HTTPS origin and `TRUSTED_ORIGINS` to the exact comma-separated dashboard origins. Set `NEXT_PUBLIC_API_URL` on the dashboard before its Docker build.
6. Generate `TOKEN_ENCRYPTION_KEY` with `openssl rand -hex 32`. Keep it stable and backed up; it protects retryable device-token delivery. Render generates a separate Better Auth secret. Do not use development sample values.
7. Deploy the database migration before starting the new API. Start the worker, then the API and dashboard. Confirm `/health`, email delivery and a real small-media upload before pairing screens.

Place API, worker and PostgreSQL in the same region. The API uses dedicated PostgreSQL listener connections for notifications; do not put those connections through transaction-mode pooling. Media processing and publication remain durable in PostgreSQL even when WebSocket connections reconnect.

## Operations

Monitor oldest pending job age, conversion failures, API errors, failed email delivery, screens missing heartbeats, desired-versus-playing version lag, worker disk/RAM, database size and R2 storage. Inspect per-screen telemetry for throttling, dropped frames and decoder fallback. Media processing errors must retain the last working playlist and surface in the UI.

Enable managed PostgreSQL backups/PITR and periodically test restore into an isolated database. Preserve the R2 bucket and encryption/auth secrets alongside backup procedures. Do not delete source or rendition objects while retained manifests still reference them.

For application rollback, deploy the previous compatible image and retain database migrations. Do not automatically reverse schema migrations against live data. Keep schema changes additive during rolling deployments. Player packages are installed manually; retain the prior `.deb` and its configuration/cache for rollback.

## Mobile and player release

Build Flutter with the deployed API URL, test email sign-in, upload, QR pairing and screen control on Android and iOS. App Store and Play Store distribution require the owner's signing identities and store accounts; simulator/debug builds do not substitute for signed releases.

Install the player package onto the pinned Raspberry Pi OS Lite image after configuring Wi-Fi. Pair using the QR/code on the display. Complete [hardware qualification](hardware-qualification.md) before deploying a fleet; the presence of a successful ARM64 build is not evidence of flicker-free playback.
