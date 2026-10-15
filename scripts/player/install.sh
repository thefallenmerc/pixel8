#!/bin/sh
set -eu
if [ "$(id -u)" -ne 0 ]; then echo "Run this installer as root." >&2; exit 1; fi
archive=${1:?usage: install.sh package.deb package.SHA256SUMS}
checksum=${2:?usage: install.sh package.deb package.SHA256SUMS}
archive=$(realpath "$archive")
checksum=$(realpath "$checksum")
"$(dirname "$0")/verify-artifact.sh" "$archive" "$checksum"
case "$archive" in
  *.deb)
    # Installing the local file through apt resolves the package's declared
    # GStreamer runtime dependencies on a fresh Raspberry Pi OS image.
    apt-get install -y "$archive"
    echo "Installed. Edit /etc/pixel8/player.toml, then run: sudo -u pixel8 pixel8-player --config /etc/pixel8/player.toml pair"
    echo "After pairing, start the service with: sudo systemctl enable --now pixel8-player.service"
    exit 0
    ;;
esac
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT HUP INT TERM
tar -xzf "$archive" -C "$stage"
test -x "$stage/usr/bin/pixel8-player"
getent group pixel8 >/dev/null || groupadd --system pixel8
id pixel8 >/dev/null 2>&1 || useradd --system --gid pixel8 --groups video,audio,render --home-dir /var/lib/pixel8 --no-create-home --shell /usr/sbin/nologin pixel8
install -d -o pixel8 -g pixel8 -m 0750 /var/lib/pixel8/cache
install -d -o root -g pixel8 -m 0770 /etc/pixel8
install -m 0755 "$stage/usr/bin/pixel8-player" /usr/bin/pixel8-player
install -m 0644 "$stage/usr/lib/systemd/system/pixel8-player.service" /usr/lib/systemd/system/pixel8-player.service
if [ ! -e /etc/pixel8/player.toml ]; then
  /usr/bin/pixel8-player --config /etc/pixel8/player.toml init-config
  chown pixel8:pixel8 /etc/pixel8/player.toml
  chmod 0600 /etc/pixel8/player.toml
fi
systemctl daemon-reload
systemctl enable pixel8-player.service
echo "Installed. Edit /etc/pixel8/player.toml, then run: sudo -u pixel8 pixel8-player --config /etc/pixel8/player.toml pair"
echo "After pairing, start the service with: sudo systemctl enable --now pixel8-player.service"
