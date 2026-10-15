# Player cache and recovery

The player stores immutable manifests in `cache/manifests` and the active and
fallback versions in `cache/STATE.json`. On startup, it validates the current
manifest and its media hashes; if that generation is damaged, it selects the
valid previous generation and repairs the state pointer. New downloads reclaim
space down to the configured quota minus the incoming unique media bytes while
keeping the incoming, current, and fallback media pinned. If those pinned files
alone exceed the quota, reconciliation fails without removing committed media.

Playlist activation is committed only after the renderer has started and the
server still reports the same desired version. Failed activation restores the
committed playlist; if no valid committed generation exists, playback is
stopped. Renderer failures are recorded locally before network ACK attempts,
and the ACK remains queued in `STATE.json` when the API is unreachable. The
telemetry state distinguishes the desired version from the generation actually
playing. Error ACKs report the desired `version` alongside the truthful
`playingVersion` (or `null` when playback stopped). When playback fell back to
an older generation, the reported item ID is selected from that generation so
the backend validates the actual state against the correct manifest.

The systemd service runs as `pixel8:pixel8` with `video`, `render`, and `audio`
supplementary groups. This lets it traverse `/etc/pixel8` while retaining access
to the display and sound devices.

## Install and pair a Raspberry Pi

Use the pinned [Raspberry Pi OS Lite Trixie ARM64 image](hardware-qualification.md#reproducible-setup)
for the release baseline. Flash it with Raspberry Pi Imager, configure the
network, and connect the Pi to the display before enabling playback. The player
package targets ARM64 and its Debian dependencies provide the required
GStreamer runtime plugins; the installer uses `apt-get install` on the local
`.deb` so those dependencies are resolved on a fresh image.

On the Pi, download the `.deb` and its matching `SHA256SUMS` manifest from the
same release. From a checkout of the matching Pixel8 source release, pass the
manifest to the installer so it verifies the selected artifact before
installation:

```sh
DEB="$HOME/pixel8-player_0.1.0_arm64.deb"
SUMS="$HOME/SHA256SUMS-0.1.0"
sudo scripts/player/verify-artifact.sh "$DEB" "$SUMS"
sudo scripts/player/install.sh "$DEB" "$SUMS"
```

The standalone `verify-artifact.sh` command is optional because `install.sh`
performs the same exact-entry checksum check itself. Keep the manifest beside
the downloaded artifact and do not substitute a checksum copied from another
release.

Set `api_base_url` in `/etc/pixel8/player.toml` to the Pixel8 API base URL,
without a trailing slash. The installer creates this file with owner-only
permissions. Pair before starting the playback service:

```sh
sudoedit /etc/pixel8/player.toml
sudo chown pixel8:pixel8 /etc/pixel8/player.toml
sudo chmod 0600 /etc/pixel8/player.toml
sudo -u pixel8 pixel8-player --config /etc/pixel8/player.toml doctor
sudo -u pixel8 pixel8-player --config /etc/pixel8/player.toml pair
```

Run the player commands as `pixel8` so its pairing credential and QR cache
remain readable by the systemd service. After editing the API URL, restore the
config file's `pixel8` ownership and owner-only mode as shown above.

The pair command displays an eight-character code and a QR code. Enter the code
in Pixel8 while signed in to the account that should own this screen. After the
player reports that pairing completed, enable and start the service:

```sh
sudo systemctl enable --now pixel8-player.service
sudo systemctl status --no-pager pixel8-player.service
sudo journalctl -u pixel8-player.service -f
```

`doctor` checks device and media prerequisites, including whether the Pi's
production `v4l2h264dec` decoder is available. A passing software build alone
does not qualify video output. Its target mode can come from DRM sysfs,
`PIXEL8_DISPLAY_MODE`, or a 720p30 default; when it is not reported by DRM
sysfs, it is only a target and does not establish the active HDMI mode. Verify
the active HDMI mode from DRM/KMS during playback using the hardware
qualification procedure for the Pi model, display, and media mix being
deployed.

Installers verify only the requested `.deb` or archive against its exact
checksum-manifest entry. This allows installing one artifact from a manifest
that also lists artifacts not present on the device. The helper’s regression
fixtures run with:

```sh
scripts/player/test-verify-artifact.sh
```

The native GStreamer CPU integration tests use `fakesink` and do not relax the
production Raspberry Pi `v4l2h264dec` requirement:

```sh
cargo test --locked --features native-gstreamer
```

The renderer keeps video-to-video publication changes on the active playbin3
pipeline and checks that rendered sink frames advance. Pairing QR refreshes and
QR-to-video handoffs rebuild the still-image `imagefreeze` branch through
`READY`; this explicitly removes the still-image filter before normal video
playback. Campaign images are normalized to video clips on the server, so this
pairing lifecycle does not apply to ordinary campaign transitions. The CPU test exercises decoded
red/blue clips, repeated wraps, live video replacement without a `READY`/`NULL`
transition, and QR refresh/handoff. It does not measure KMS scanout latency,
physical black frames, HDMI mode stability, or V4L2 decoder behavior; qualify
those on the target Pi using [hardware qualification](hardware-qualification.md).
