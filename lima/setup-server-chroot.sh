#!/bin/bash
set -e

if [ ! -f "/srv/mrva/server-root/.bootstrapped" ]; then
    echo "[1/6] Bootstrapping Debian into /srv/mrva/server-root"
    sudo debootstrap --variant=minbase bookworm "/srv/mrva/server-root" http://deb.debian.org/debian
    sudo touch "/srv/mrva/server-root/.bootstrapped"
fi


if [ ! -f "/srv/mrva/server-root/.packages_installed" ]; then
    echo "[2/6] Installing base packages"
    sudo mount -t proc none "/srv/mrva/server-root/proc"
    sudo chroot "/srv/mrva/server-root" bash -c "
    apt-get update &&
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      default-jdk
    "
    sudo umount "/srv/mrva/server-root/proc"
    sudo touch "/srv/mrva/server-root/.packages_installed"
fi


if [ ! -f "/srv/mrva/server-root/opt/codeql/codeql" ]; then
    echo "[3/6] Installing CodeQL CLI"
    echo "  -> Using CodeQL version: v2.21.3"
    mkdir -p "/srv/mrva/server-root/opt"
    curl -L "https://github.com/github/codeql-cli-binaries/releases/download/v2.21.3/codeql-linux64.zip" -o /tmp/codeql.zip
    sudo unzip -q /tmp/codeql.zip -d "/srv/mrva/server-root/opt"
    # optional: rm /tmp/codeql.zip
fi


if [ ! -f "/srv/mrva/server-root/etc/profile.d/codeql.sh" ]; then
    echo "[4/6] Adding CodeQL environment to chroot"
    sudo tee "/srv/mrva/server-root/etc/profile.d/codeql.sh" > /dev/null <<EOF
export CODEQL_CLI_PATH=/opt/codeql/codeql
export CODEQL_JAVA_HOME=/usr
EOF
fi


if ! /usr/local/go/bin/go version | grep -q "1.22.0"; then
    echo "[5/6] Installing Go 1.22.0"
    cd /usr/local
    sudo curl -LO "https://go.dev/dl/go1.22.0.linux-arm64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -xzf "go1.22.0.linux-arm64.tar.gz"
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo apt remove -y golang || true
fi


echo "[6/6] Building mrvaserver Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "/Users/hohn/work-gh/mrva/mrvaserver"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o mrvaserver-binary
echo "  -> Installing binary to chroot"
sudo cp mrvaserver-binary "/srv/mrva/server-root/usr/local/bin/mrvaserver"
ls -la "/srv/mrva/server-root/usr/local/bin/mrvaserver"

