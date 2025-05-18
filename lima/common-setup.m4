dnl $1 -- CHROOT_ROOT: root of chroot to populate
define(`CHROOT_BOOTSTRAP', `
if [ ! -f "$1/.bootstrapped" ]; then
    echo "[1/6] Bootstrapping Debian into $1"
    sudo debootstrap --variant=minbase bookworm "$1" http://deb.debian.org/debian
    sudo touch "$1/.bootstrapped"
fi
')

dnl $1 -- CHROOT_ROOT: root of chroot to install into
define(`CHROOT_INSTALL_BASE_PACKAGES', `
if [ ! -f "$1/.packages_installed" ]; then
    echo "[2/6] Installing base packages"
    sudo mount -t proc none "$1/proc"
    sudo chroot "$1" bash -c "
    apt-get update &&
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      default-jdk
    "
    sudo umount "$1/proc"
    sudo touch "$1/.packages_installed"
fi
')

dnl $1 -- CHROOT_ROOT: chroot to install into
dnl $2 -- CODEQL_TAG: release tag like v2.21.3
define(`CHROOT_INSTALL_CODEQL', `
if [ ! -f "$1/opt/codeql/codeql" ]; then
    echo "[3/6] Installing CodeQL CLI"
    echo "  -> Using CodeQL version: $2"
    mkdir -p "$1/opt"
    curl -L "https://github.com/github/codeql-cli-binaries/releases/download/$2/codeql-linux64.zip" -o /tmp/codeql.zip
    sudo unzip -q /tmp/codeql.zip -d "$1/opt"
    # optional: rm /tmp/codeql.zip
fi
')

dnl $1 -- CHROOT_ROOT: chroot where env vars are added
define(`CHROOT_SET_CODEQL_ENV', `
if [ ! -f "$1/etc/profile.d/codeql.sh" ]; then
    echo "[4/6] Adding CodeQL environment to chroot"
    sudo tee "$1/etc/profile.d/codeql.sh" > /dev/null <<EOF
export CODEQL_CLI_PATH=/opt/codeql/codeql
export CODEQL_JAVA_HOME=/usr
EOF
fi
')

dnl $1 -- GO_VERSION: version string like 1.22.0
define(`INSTALL_GO_TOOLCHAIN', `
if ! /usr/local/go/bin/go version | grep -q "$1"; then
    echo "[5/6] Installing Go $1"
    cd /usr/local
    sudo curl -LO "https://go.dev/dl/go$1.linux-arm64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -xzf "go$1.linux-arm64.tar.gz"
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo apt remove -y golang || true
fi
')

dnl $1 -- CHROOT_ROOT: chroot to install binary into
dnl $2 -- GO_SRC_DIR: host Go project path
dnl $3 -- BIN_NAME: output binary name (e.g. mrvaagent)
define(`BUILD_AND_COPY_GO_BINARY', `
echo "[6/6] Building $3 Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "$2"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o $3-binary
echo "  -> Installing binary to chroot"
sudo cp $3-binary "$1/usr/local/bin/$3"
ls -la "$1/usr/local/bin/$3"
')
