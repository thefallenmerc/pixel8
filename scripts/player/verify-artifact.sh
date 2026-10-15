#!/bin/sh
set -eu
artifact=$(realpath "${1:?usage: verify-artifact.sh archive checksum-manifest}")
manifest=$(realpath "${2:?usage: verify-artifact.sh archive checksum-manifest}")
name=$(basename "$artifact")
expected=$(awk -v wanted="$name" '$2 == wanted || $2 == "*" wanted { count++; digest=$1 } END { if (count != 1) exit 1; print digest }' "$manifest") || {
  echo "Checksum manifest must contain exactly one entry for $name." >&2
  exit 1
}
case "$expected" in
  *[!0-9a-fA-F]*|'') echo "Invalid checksum entry for $name." >&2; exit 1 ;;
esac
if [ "${#expected}" -ne 64 ]; then
  echo "Invalid checksum entry for $name." >&2
  exit 1
fi
actual=$(sha256sum "$artifact" | awk '{ print $1 }')
if [ "$actual" != "$expected" ]; then
  echo "Checksum mismatch for $name." >&2
  exit 1
fi
echo "Verified $name"
