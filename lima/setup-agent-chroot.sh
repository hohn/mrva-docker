#!/bin/bash
set -e

# === Config ===
CHROOT_ROOT=/srv/mrva/agent-root
# # linux host
# GO_SRC_DIR=/home/hohn/work-gh/mrva/mrvaagent
# mac host
GO_SRC_DIR=/Users/hohn/work-gh/mrva/mrvaagent

GO_VERSION=1.22.0
CODEQL_TAG=v2.21.3

# === Step 1: Bootstrap base system ===
if [ ! -f "$CHROOT_ROOT/.bootstrapped" ]; then
    echo "[1/6] Bootstrapping Debian into $CHROOT_ROOT"
    sudo debootstrap --variant=minbase bookworm "$CHROOT_ROOT" http://deb.debian.org/debian
    sudo touch "$CHROOT_ROOT/.bootstrapped"
fi

# === Step 2: Install base packages ===
if [ ! -f "$CHROOT_ROOT/.packages_installed" ]; then
    echo "[2/6] Installing base packages"
    sudo mount -t proc none "$CHROOT_ROOT/proc"
    sudo chroot "$CHROOT_ROOT" bash -c "
    apt-get update &&
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      default-jdk
    "
    sudo umount "$CHROOT_ROOT/proc"
    sudo touch "$CHROOT_ROOT/.packages_installed"
fi

# === Step 3: Install CodeQL CLI ===
if [ ! -f "$CHROOT_ROOT/opt/codeql/codeql" ]; then
    echo "[3/6] Installing CodeQL CLI"
    echo "  -> Using CodeQL version: $CODEQL_TAG"
    mkdir -p "$CHROOT_ROOT/opt"
    curl -L "https://github.com/github/codeql-cli-binaries/releases/download/$CODEQL_TAG/codeql-linux64.zip" -o /tmp/codeql.zip
    sudo unzip -q /tmp/codeql.zip -d "$CHROOT_ROOT/opt"
    # optional: rm /tmp/codeql.zip
fi

# === Step 4: Set CodeQL env vars ===
if [ ! -f "$CHROOT_ROOT/etc/profile.d/codeql.sh" ]; then
    echo "[4/6] Adding CodeQL environment to chroot"
    sudo tee "$CHROOT_ROOT/etc/profile.d/codeql.sh" > /dev/null <<EOF
export CODEQL_CLI_PATH=/opt/codeql/codeql
export CODEQL_JAVA_HOME=/usr
EOF
fi

# === Step 5: Install Go toolchain ===
if ! /usr/local/go/bin/go version | grep -q "$GO_VERSION"; then
    echo "[5/6] Installing Go $GO_VERSION"
    cd /usr/local
    sudo curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -xzf "go${GO_VERSION}.linux-arm64.tar.gz"
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo apt remove -y golang || true
fi

# === Step 6: Build Go binary ===
echo "[6/6] Building mrvaagent Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "$GO_SRC_DIR"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o mrvaagent-binary
echo "  -> Installing binary to chroot"
sudo cp mrvaagent-binary "$CHROOT_ROOT/usr/local/bin/mrvaagent"
ls -la "$CHROOT_ROOT/usr/local/bin/mrvaagent"
