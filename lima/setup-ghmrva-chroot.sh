#!/bin/bash
set -e

# === Config ===
CHROOT_ROOT=/srv/mrva/ghmrva-root
GO_SRC_DIR=/Users/hohn/work-gh/mrva/gh-mrva
GO_VERSION=1.22.0

# === Step 6: Build Go binary (gh-mrva) ===
echo "[6/6] Building gh-mrva Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "$GO_SRC_DIR"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o gh-mrva
echo "  -> Installing binary to chroot"
sudo mkdir -p "$CHROOT_ROOT/usr/local/bin"
sudo cp gh-mrva "$CHROOT_ROOT/usr/local/bin/gh-mrva"
ls -la "$CHROOT_ROOT/usr/local/bin/gh-mrva"
