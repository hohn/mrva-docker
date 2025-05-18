
if [ ! -f "/srv/mrva/ghmrva-root/.bootstrapped" ]; then
    echo "[1/6] Bootstrapping Debian into /srv/mrva/ghmrva-root"
    sudo debootstrap --variant=minbase bookworm "/srv/mrva/ghmrva-root" http://deb.debian.org/debian
    sudo touch "/srv/mrva/ghmrva-root/.bootstrapped"
fi


if [ ! -f "/srv/mrva/ghmrva-root/.packages_installed" ]; then
    echo "[2/6] Installing base packages"
    sudo mount -t proc none "/srv/mrva/ghmrva-root/proc"
    sudo chroot "/srv/mrva/ghmrva-root" bash -c "
    apt-get update &&
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      default-jdk
    "
    sudo umount "/srv/mrva/ghmrva-root/proc"
    sudo touch "/srv/mrva/ghmrva-root/.packages_installed"
fi


if [ ! -f "/srv/mrva/ghmrva-root/opt/codeql/codeql" ]; then
    echo "[3/6] Installing CodeQL CLI"
    echo "  -> Using CodeQL version: v2.21.3"
    mkdir -p "/srv/mrva/ghmrva-root/opt"
    curl -L "https://github.com/github/codeql-cli-binaries/releases/download/v2.21.3/codeql-linux64.zip" -o /tmp/codeql.zip
    sudo unzip -q /tmp/codeql.zip -d "/srv/mrva/ghmrva-root/opt"
    # optional: rm /tmp/codeql.zip
fi


if [ ! -f "/srv/mrva/ghmrva-root/etc/profile.d/codeql.sh" ]; then
    echo "[4/6] Adding CodeQL environment to chroot"
    sudo tee "/srv/mrva/ghmrva-root/etc/profile.d/codeql.sh" > /dev/null <<EOF
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


echo "[6/6] Building gh-mrva Go binary"
export PATH=/usr/local/go/bin:$PATH
cd "/Users/hohn/work-gh/mrva/gh-mrva"
export GO111MODULE=on
export CGO_ENABLED=0
go build -o gh-mrva-binary
echo "  -> Installing binary to chroot"
sudo cp gh-mrva-binary "/srv/mrva/ghmrva-root/usr/local/bin/gh-mrva"
ls -la "/srv/mrva/ghmrva-root/usr/local/bin/gh-mrva"

