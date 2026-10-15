# Verification record

This record distinguishes automated software checks from physical display qualification. Development credentials, local email messages and generated build caches are excluded from Git.

## Checkpoint before local cleanup — 2026-10-15

Source is preserved on the `dev` branch of `thefallenmerc/pixel8`. The user requested a commit, push and removal of the local checkout before native-player release work finished.

The native renderer regression passed once but subsequently hung intermittently during repeated stop/start testing. Its final repeated run, full Rust suite and refreshed ARM64 package are **not complete**. Investigate bus-driven `set_state(Playing)` racing with intentional READY transitions; do not claim the race fixed without repeated tests. The existing `services/player/dist` binaries predate the final renderer changes and are not release candidates.

The qualification guide proposes the pinned Trixie image, and a Trixie test Dockerfile is present, but the release builder and Debian dependency minimum still need to be reconciled with that baseline after tests pass. The backend, dashboard and Android results below remain the completed checks. iOS packaging and physical Pi qualification remain outstanding.

## Verified during implementation

- Local PostgreSQL, private S3-compatible storage and Mailpit start through Docker Compose.
- Email OTP delivery and sign-in were exercised against the real local API and Mailpit, without an authentication bypass.
- API, media worker and shared TypeScript packages have passed type checking and compilation. They are rerun after integration changes.
- The Rust native GStreamer feature has compiled inside an ARM64 Debian Bookworm container, including an optimized release build. This proves compilation and ABI linkage, not Pi hardware playback.
- Rust tests exercise hash/size validation, cache generations and fallback, quota pinning, EDID parsing, and shared manifest/telemetry fixtures.
- Flutter API and widget tests passed (8 tests), and an Android debug APK was built. The APK is a development artifact, not a signed store release.
- The browser flow exercised real email sign-in, app creation, PNG/MP4 multipart upload, mixed campaign Save, Preparing → Ready, code pairing, and campaign assignment.
- The assigned simulator downloaded both renditions and verified their manifest byte counts and SHA-256 hashes. FFprobe reported H.264 1280×720 at 30 fps, AAC stereo at 48 kHz, a 10-second image clip and the original video's full 2-second duration. FFmpeg decoded both without errors.
- A deliberately labeled simulator submitted playback acknowledgements and telemetry; the dashboard reflected the reported version. Changing orientation advanced the desired version while retaining the earlier playing version and showing Waiting. Heartbeat expiry changed the screen to Offline. These are protocol/UI checks, not evidence of Raspberry Pi rendering.
- Shared manifest, empty-manifest, telemetry and acknowledgement fixtures validate against the TypeScript contracts.

## Backend integration results

The live backend smoke passed on 2026-10-11 against local PostgreSQL, Mailpit, LocalStack, a separate media worker, and two API instances on ports 3001 and 3002. It exercised real OTP sign-in and persisted throttling, tenant isolation, pairing claim/reuse/expiry/revocation, CORS preflight, expected-version CAS, playback fallback/stopped/same-version recovery, PNG/HEIC/MP4 processing, campaign/settings/capability publication races, latest telemetry in screen list/detail/mutation responses, and failed-candidate retention. It also performed late-arriving telemetry aggregation, concurrent and sequential upload completion retries with exactly one outbox row, and forced termination of both API PostgreSQL LISTEN sessions followed by reconnect and notification delivery while both APIs remained ready.

The load regression created 100 simulator credentials, opened 100 authenticated WebSockets split evenly across the two APIs, closed and reconnected all 100 during a campaign revision, and verified all received current-version hints. All 100 screens then received the mixed-media publication, and 200 manifest/ACK requests completed at concurrency 20. Recorded timings: 3.598 s to assign, 6.493 s for reconnect plus publication hints, 6.725 s for 100-screen publication, and 1.825 s for the manifest/ACK requests. These bounded values are regression measurements, not a capacity or sustained-load claim. Simulator screens and the test app were cleaned up.

`pnpm --filter @pixel8/api build`, `pnpm --filter @pixel8/worker build`, `pnpm test:contracts`, and the full workspace `pnpm typecheck` passed after the final backend changes. The dashboard passed 10 component tests and TypeScript checking, and its production Docker build passed. Flutter passed all 8 tests after regenerating the Dart SDK; analysis reported no errors or warnings. The Dart SDK's targeted tests also verified omitted/null/numeric playback versions and explicit-null screen unassignment. The local Docker stack had been restarted and fixtures were freshly uploaded after storage resets.

The final API production Docker image built from the frozen backend source and started against the local PostgreSQL container; `/health` and the database-backed `/ready` endpoint both returned HTTP 200. The production dashboard image returned HTTP 200 from `/`. The final worker image built from the frozen backend source (image ID `sha256:579c71698ed8bd6e84db6724fb689fe0038682e53be0dd2aadcdf8c2a542e8f3`) and started against the task-local PostgreSQL container, logging `Pixel8 media worker started`. All temporary smoke containers were stopped and removed after verification.

The final API image also passed a repeated device-capabilities PUT regression against an existing synthetic credential. The same capabilities payload with reordered JSON keys returned desired versions `[5, 5]`, confirming JSONB key ordering does not advance the screen version when capability values are unchanged.

iOS simulator and unsigned-device build attempts stopped before compilation because Xcode's iOS 26.5 platform component is not installed. Install that platform and rerun the documented Flutter build before claiming iOS packaging validation.

The final Android development APK was packaged from the final Flutter/Dart sources with `--debug --target-platform android-arm64 --dart-define=PIXEL8_API=http://10.0.2.2:3001`. Disk exhaustion interrupted Flutter's copy of the completed Gradle APK; the intact Gradle output was recovered and passed ZIP integrity and Android APK v2 signature verification. Its SHA-256 is `bb99ba092bb304d3893707fb60ffe8ed3e1012d1fe25c56b1a4662906d9ab641`. The file is `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`. This is an emulator-oriented development build; physical phones and deployment need reachable API and storage endpoints as described in [mobile.md](mobile.md).

## Physical qualification

No Raspberry Pi was connected during software implementation. V4L2 decoding, KMS output, HDMI audio, resource limits, transition behavior and the 24-hour mixed-content run remain unverified. Follow [hardware-qualification.md](hardware-qualification.md), using the pinned image and checksums, and attach measured results before fleet release.
