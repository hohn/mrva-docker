#!/bin/bash
set -e

# === Config ===
CHROOT_ROOT=/srv/mrva/server-root
GO_SRC_DIR=/Users/hohn/work-gh/mrva/mrvaserver
GO_VERSION=1.22.0

# === Step 6: Build Go binary (server) ===
echo "[6/6] Building mrvaserver Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "$GO_SRC_DIR"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o mrvaserver-binary
echo "  -> Installing binary to chroot"
sudo mkdir -p "$CHROOT_ROOT/usr/local/bin"
sudo cp mrvaserver-binary "$CHROOT_ROOT/usr/local/bin/mrvaserver"
ls -la "$CHROOT_ROOT/usr/local/bin/mrvaserver"
