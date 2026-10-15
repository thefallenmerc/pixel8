#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
"$repo_dir/scripts/player/build-arm64.sh"
crate="$repo_dir/services/player"
target_dir=${CARGO_TARGET_DIR:-"$crate/target"}
version=$(awk '/^\[package\]$/ { in_package=1; next } /^\[/ { in_package=0 } in_package && /^version[[:space:]]*=/ { match($0, /"[^"]+"/); print substr($0, RSTART+1, RLENGTH-2); exit }' "$crate/Cargo.toml")
stage="$crate/target/package"
debstage="$crate/target/deb"
dist="$repo_dir/services/player/dist"
rm -rf "$stage" "$debstage"
mkdir -p "$stage/usr/bin" "$stage/usr/lib/systemd/system" "$stage/usr/share/doc/pixel8-player" "$debstage/DEBIAN" "$debstage/usr/bin" "$debstage/usr/lib/systemd/system" "$debstage/usr/share/doc/pixel8-player" "$dist"
cat "$target_dir/release/pixel8-player" > "$stage/usr/bin/pixel8-player"
chmod 0755 "$stage/usr/bin/pixel8-player"
install -m 0644 "$crate/packaging/pixel8-player.service" "$stage/usr/lib/systemd/system/pixel8-player.service"
install -m 0644 "$crate/packaging/player.toml.example" "$stage/usr/share/doc/pixel8-player/player.toml.example"
tar -C "$stage" -czf "$dist/pixel8-player-${version}-aarch64-linux.tar.gz" usr
cp -a "$stage"/. "$debstage"/
sed "s/^Version:.*/Version: $version/" "$crate/packaging/debian-control" > "$debstage/DEBIAN/control"
install -m 0755 "$crate/packaging/debian-postinst" "$debstage/DEBIAN/postinst"
install -m 0755 "$crate/packaging/debian-prerm" "$debstage/DEBIAN/prerm"
dpkg-deb --build --root-owner-group -Zxz "$debstage" "$dist/pixel8-player_${version}_arm64.deb"
(cd "$dist" && sha256sum "pixel8-player-${version}-aarch64-linux.tar.gz" "pixel8-player_${version}_arm64.deb" > "SHA256SUMS-${version}")
rm -rf "$stage" "$debstage"
echo "Packages: $dist/pixel8-player_${version}_arm64.deb and $dist/pixel8-player-${version}-aarch64-linux.tar.gz"
echo "Checksums: $dist/SHA256SUMS-${version}"
