#!/bin/sh
set -eu

# The CPU integration suite decodes H.264/AAC fixture files through playbin3.
# Keep these runtime codecs in the test image only; deployment relies on the
# target's hardware decoder and does not ship fakesink support.
if command -v apt-get >/dev/null 2>&1; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gstreamer1.0-plugins-good gstreamer1.0-libav
fi

cargo test --locked --features native-gstreamer
