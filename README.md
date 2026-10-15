# Pixel8_2

Control Raspberry Pi displays from your phone or browser. An account owns apps, apps contain media and campaigns, and each physical screen plays one assigned campaign. Saving a campaign prepares a new immutable version. Screens keep their last working playlist while the replacement is processed and downloaded.

## Repository

| Directory | Responsibility |
| --- | --- |
| `apps/mobile` | Flutter Android and iOS control app |
| `apps/web` | Next.js browser dashboard |
| `services/api` | Fastify authentication, management API, pairing, manifests and telemetry |
| `services/worker` | Media probing, thumbnails, renditions and publication |
| `services/player` | Rust/GStreamer executable, local cache and systemd packaging |
| `packages/contracts` | Shared validation and protocol types |
| `packages/database` | Prisma schema and database migrations |
| `packages/sdk-ts`, `packages/sdk-dart` | OpenAPI client artifacts |
| `docs` | Setup, deployment, protocol and qualification guides |

## Local development

Requirements: Node.js 22.13+, pnpm 11.25.0 (pinned in `package.json`), Docker Compose, FFmpeg/ffprobe, Flutter for mobile development, and Rust for player development. The native player additionally requires GStreamer development/runtime packages. Production playback is built for Raspberry Pi OS Lite ARM64; development protocol tests do not require a Pi.

```sh
cp .env.example .env
docker compose up -d
pnpm install
pnpm db:generate
pnpm db:migrate
```

Start the API, worker and dashboard in separate terminals:

```sh
pnpm dev:api
pnpm dev:worker
pnpm dev:web
```

Open the dashboard at http://localhost:3000. During local development, email verification codes arrive in Mailpit at http://localhost:18025. Sign in with an email address, create an app, upload media, create a campaign, then pair a player and select **Show on screen**.

The Compose stack is dedicated to this project: PostgreSQL on port 54328, LocalStack S3 on port 19000, Mailpit SMTP on 11025 and its inbox on 18025. Its bucket is private and initialized with local browser CORS rules. LocalStack data is disposable; originals intended for permanent use belong in production object storage. `docker compose down` stops the stack; adding `--volumes` also removes the development database.

Never use `.env.example` credentials in deployment. Production uses private R2 storage and Resend delivery; no development authentication bypass is provided.

## Setup and verification guides

- [Mobile setup](docs/mobile.md) and [web dashboard](docs/web.md)
- [Backend and simulator checks](docs/backend.md) and [shared API contract](docs/contract.md)
- [Pi installation and recovery](docs/player.md)
- [Managed deployment](docs/deployment.md)
- [Completed checks and remaining qualification](docs/verification.md)

## Playback and updates

- An image, a video, and a mixed slideshow all use the same ordered campaign model.
- Images default to ten seconds; videos use their complete probed duration. Sound is muted by default and can be enabled per screen.
- Screen versions and campaign revisions are separate. Switching campaigns cannot reactivate an older screen assignment.
- Notifications tell devices to reconcile; the authoritative manifest is fetched on startup, reconnect and periodically.
- Devices verify downloaded sizes and SHA-256 hashes before activation. Current and previous generations remain pinned in the local cache.
- Offline devices keep cached content. Deletion or reassignment reaches them after reconnection.
- “Saved”, “Preparing”, “Downloading” and “Playing” are different states. Playback is acknowledged only after the renderer starts.

## Hardware qualification

The Pi Zero 2 W has 512 MB RAM and a 1080p30 H.264 hardware ceiling. The initial playback profile is 720p30; 1080p remains opt-in pending qualification. Server renditions account for display orientation, fit, decoder capability and physical scanout dimensions.

No physical Pi was available during initial development. Automated protocol tests and desktop builds cannot establish hardware decoding performance, HDMI audio quality or flicker-free transitions. Follow [the hardware qualification procedure](docs/hardware-qualification.md) before treating a player build as deployment-qualified.

## Product boundaries

This release is designed for up to 100 independently playing screens and one owner per account. Calendar scheduling, teams, multi-zone layouts, synchronized video walls and automatic player-software updates are outside this release. Media updates are automatic after Save; player software is installed as a versioned package.
