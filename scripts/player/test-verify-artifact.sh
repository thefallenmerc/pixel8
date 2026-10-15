#!/bin/sh
set -eu
repo=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
verify="$repo/scripts/player/verify-artifact.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
printf 'package bytes\n' > "$tmp/player.deb"
printf 'unrelated tarball is intentionally absent\n' > "$tmp/other.tar.gz"
(cd "$tmp" && sha256sum player.deb other.tar.gz > sums)
rm "$tmp/other.tar.gz"
"$verify" "$tmp/player.deb" "$tmp/sums" >/dev/null

mkdir "$tmp/manifest-dir" "$tmp/artifact-dir"
printf 'trusted bytes\n' > "$tmp/manifest-dir/same.deb"
printf 'tampered bytes\n' > "$tmp/artifact-dir/same.deb"
(cd "$tmp/manifest-dir" && sha256sum same.deb > ../same-name.sums)
if "$verify" "$tmp/artifact-dir/same.deb" "$tmp/same-name.sums" >/dev/null 2>&1; then
  echo "same-name artifact from another directory unexpectedly passed" >&2
  exit 1
fi

printf 'tampered bytes\n' > "$tmp/player.deb"
if "$verify" "$tmp/player.deb" "$tmp/sums" >/dev/null 2>&1; then
  echo "tampered package unexpectedly passed checksum validation" >&2
  exit 1
fi
printf 'package bytes\n' > "$tmp/player.deb"
sha=$(sha256sum "$tmp/player.deb" | awk '{print $1}')
printf '%s  player.deb\n' "$sha" > "$tmp/missing-entry.sums"
if "$verify" "$tmp/other.deb" "$tmp/missing-entry.sums" >/dev/null 2>&1; then
  echo "missing package entry unexpectedly passed checksum validation" >&2
  exit 1
fi
printf '%s  player.deb\n%s  player.deb\n' "$sha" "$sha" > "$tmp/duplicate.sums"
if "$verify" "$tmp/player.deb" "$tmp/duplicate.sums" >/dev/null 2>&1; then
  echo "duplicate package entries unexpectedly passed checksum validation" >&2
  exit 1
fi
echo "artifact checksum validation tests passed"
