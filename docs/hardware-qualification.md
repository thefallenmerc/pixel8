# Pi Zero 2 W qualification

Status: **pending physical hardware**. Simulation tests establish protocol and cache behavior, not real HDMI playback performance.

## Reproducible setup

The initial qualification baseline is Raspberry Pi OS Lite **Trixie ARM64, 2026-10-06**, matching the Debian 13 native build container and GStreamer 1.26 runtime baseline. Download the [official image](https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2026-10-06/2026-10-06-raspios-trixie-arm64-lite.img.xz) and verify its [published checksum](https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2026-10-06/2026-10-06-raspios-trixie-arm64-lite.img.xz.sha256):

```text
483db18a48da399b5b7022ffae9a07bc6d99daab30e593aedac09b69ff422843  2026-10-06-raspios-trixie-arm64-lite.img.xz
```

This pin is a reproducible test baseline, not a recommendation to leave security updates unapplied. Apply required updates before fleet release, record the resulting package versions, and repeat qualification when kernel, firmware or GStreamer changes.

Record the Pi model, power supply, SD card, display model, HDMI cable, OS image checksum, kernel, GStreamer package versions, player build checksum and `pixel8-player doctor` report. Use Raspberry Pi OS Lite ARM64 and preconfigure Wi-Fi with Raspberry Pi Imager. Connect the display before starting the service.

Start with the 720p30 profile. Keep `supports1080p` disabled until its complete separate test run passes. Confirm the selected decoder is V4L2 H.264; smooth-looking output alone is not proof of hardware decoding. Verify the actual active HDMI mode from DRM/KMS while playback is running and record it separately from the logical portrait canvas. `pixel8-player doctor` may show a target mode from `PIXEL8_DISPLAY_MODE` or the 720p30 default when DRM sysfs has no active-mode readout; that value is not a measurement and does not satisfy this gate. Do not claim HDMI mode qualification until the active DRM/KMS readout agrees with the expected scanout.

## Transition capture

Use an HDMI capture device or a high-frame-rate camera with a test set containing visible frame markers. Include JPEG, PNG, HEIC, portrait images, transparent images, landscape and portrait videos, silent videos and HDMI audio videos. Include 4K and high-frame-rate source files to verify server normalization.

Test image-to-image, image-to-video, video-to-image, video-to-video, final-to-first, single-image hold, single-video loop, playlist replacement, empty playlist, orientation changes and mute/volume changes. Run at least 10,000 ordinary transitions and capture update transitions separately.

Acceptance: no unintended black frame and no HDMI mode reset during normal transitions or playlist activation. Deliberately empty content, boot, cable reconnect and recovery from a renderer crash are distinct events. Measure retained-frame delay instead of labeling any observed pause “gapless”. Record p50, p95, p99 and maximum transition delay.

## Resource and stability run

Run a mixed playlist for 24 hours while alternating idle periods, downloads and network interruptions. Collect CPU, process RSS, system available memory, temperature, throttling, dropped frames, decoder name and HDMI audio errors.

Initial engineering targets, not measured claims: less than 0.1% dropped frames, no sustained software-decoder fallback, no OOM or swap pressure, no sustained thermal throttling, no unexpected restart, and no unbounded memory/cache/log growth. The player should leave at least 64 MiB system memory available under load. Investigate every underrun and unintended audio pop.

## Recovery cases

1. Disconnect Wi-Fi for an hour; reboot offline and confirm cached playback starts without DNS or server access.
2. Interrupt a download, expire its signed grant, reconnect and verify transfer recovery.
3. Exhaust staging space; existing playback must continue and the dashboard must show the failed update.
4. Corrupt a cached candidate file; reject it without acknowledging playback.
5. Cut power during staging, pointer activation and cache cleanup; boot into a complete generation.
6. Save several revisions rapidly and switch campaigns during download; an older assignment must never become active afterward.
7. Restart the API, media worker and PostgreSQL listener independently; reconciliation must repair missed notifications.
8. Kill the renderer, unplug/reconnect HDMI and reboot the Pi; record recovery time and verify the error is reported.
9. Remove the final playlist item and unassign a screen; each should enter intentional idle output after receiving the new state.

## Release record

Attach the OS and package checksums, commands, media fixture hashes, resource CSV, transition capture, failure logs and pass/fail report to the release. A failed run requires a concrete fix and repetition of the affected cases. Do not substitute a different renderer or silently lower the no-black-frame requirement.
