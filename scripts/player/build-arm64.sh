#!/bin/sh
set -eu
cd "$(dirname "$0")/../../services/player"
test "$(uname -s)/$(uname -m)" = "Linux/aarch64" || { echo "Build this package on ARM64 Debian (got $(uname -s)/$(uname -m))." >&2; exit 1; }
command -v cargo >/dev/null || { echo "cargo is required" >&2; exit 1; }
command -v pkg-config >/dev/null || { echo "pkg-config is required" >&2; exit 1; }
pkg-config --atleast-version=1.22 gstreamer-1.0 || { echo "GStreamer 1.22+ development files are required" >&2; exit 1; }
# The build host need not be a Raspberry Pi. Runtime plugin/device checks belong
# in `pixel8-player doctor` and renderer startup on the target device.
cargo build --release --locked --features native-gstreamer
