# Backend and media worker

The API and media worker are separate Node.js processes. The API owns email OTP authentication, tenant-scoped CRUD, pairing, upload grants, desired-state publication, device acknowledgements, telemetry ingestion, and WebSocket notifications. The worker claims durable `pg-boss` jobs and produces image thumbnails and versioned video renditions. PostgreSQL is the source of truth for campaign revisions, immutable per-screen manifests, job outbox records, and telemetry. S3-compatible storage holds source objects and generated media.

## Run locally

Start PostgreSQL, LocalStack S3, and Mailpit with `docker compose up -d --wait`, copy `.env.example` to `.env`, then run:

```sh
pnpm install
pnpm db:generate
pnpm db:migrate
pnpm dev:api
pnpm dev:worker
```

The API listens on port 3001 by default. `GET /health` is a liveness check and `GET /ready` verifies database connectivity. In development, configure `S3_ENDPOINT` for server-side storage and `S3_PUBLIC_ENDPOINT` for signed URLs reachable by the client (for example, Android emulator clients need `http://10.0.2.2:19000`). `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`, `S3_FORCE_PATH_STYLE`, `S3_BUCKET`, and `S3_REGION` configure the storage client. `MAX_UPLOAD_BYTES` defaults to the contract limit of 20,000,000,000 bytes. The worker uses `FFMPEG_PATH` and `FFPROBE_PATH` when set; otherwise both executables must be on `PATH`. HEIC input uses `heif-convert` as a fallback when the installed `sharp` build cannot decode it.

Production email delivery uses Resend. Set `RESEND_API_KEY` and the configured sender; local development routes Better Auth email OTP through Mailpit SMTP. Keep the API and web UI on the same site (or behind a same-origin auth proxy) so browser session cookies remain available; separate default `*.onrender.com` hostnames are cross-site and do not satisfy the browser cookie policy.

## Data and delivery guarantees

Upload completion is idempotent and creates an outbox job in the same database transaction as the asset state change. The API creates the named pg-boss queues before relaying outbox rows and only marks a row delivered after pg-boss returns a job ID or confirms that the deterministic job ID already exists. Worker publication uses revision and screen desired-state compare-and-swap checks. A failed candidate retains the previous published revision while exposing the candidate failure. Stored manifests capture the campaign revision and screen settings for their version and are served as immutable snapshots. Removing a campaign or changing screen assignment advances the screen desired version and publishes an empty manifest when appropriate.

Device credentials are bearer tokens whose hashes are stored by the API; the pairing response is encrypted at rest until the device polls it. Device APIs check token ownership and active screen state. `idle` acknowledgement is valid only for an empty manifest; `playing` acknowledgement is valid only when the manifest contains the acknowledged item. Telemetry raw rows are retained for 30 days, then hourly aggregates remain for 90 days.

## Verification

Run `pnpm typecheck`, `pnpm test:contracts`, and `pnpm exec dotenv -e .env -- node scripts/backend-smoke.mjs` with the local services and API/worker running. Start a second API with `PORT=3002` and set `SECONDARY_API_URL=http://localhost:3002` to exercise the two-replica checks. The live smoke signs in through Mailpit OTP (and bootstraps an owner if the cookie file is absent), checks credentialed browser CORS preflight, tenant isolation, OTP throttling, pairing claim/reuse/expiry/revocation, expected-version races, PNG/HEIC/MP4 processing, source preview grants, settings/capability publication races, latest telemetry, truthful error playback versions and same-version recovery, failed-candidate retention, and a 100-screen campaign publication. It opens 100 authenticated WebSockets split between both APIs, closes and reconnects them during publication, and checks all 100 receive the current version; it then sends 100 manifest requests and 100 playback acknowledgements at concurrency 20. It reports assignment, reconnect/publication, publication, and HTTP-request timings. Simulator rows are removed afterward.

The smoke also retries one multipart completion concurrently and sequentially and asserts exactly one asset outbox job exists. It terminates only PostgreSQL sessions whose last query is `LISTEN pixel8_screen`, verifies both APIs reconnect and remain ready, then confirms a fresh screen change reaches a device socket. The retention regression inserts an older telemetry sample, aggregates it, inserts another sample for the same hour, and checks the additive counts, weighted averages, and maxima.

On the local run recorded 2026-10-11, assignment to 100 screens took 3.598 s, the close/reconnect plus publication hints took 6.493 s, 100-screen publication took 6.725 s, and 200 manifest/ACK requests at concurrency 20 took 1.825 s. The 100 WebSockets were opened simultaneously, split across the two API instances, then closed and reopened during a campaign revision; this is a bounded reconnect regression, not a sustained capacity benchmark. It does not measure simultaneous transcodes or a 90-day retention run.
