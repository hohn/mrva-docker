#!/bin/bash
# === machine setup ===
sudo apt update

sudo apt install -y debootstrap unzip golang git

# === Config ===
CHROOT_ROOT=/srv/mrva/agent-root

# # linux host
# GO_SRC_DIR=/home/hohn/work-gh/mrva/mrvaagent

# mac host
GO_SRC_DIR=/Users/hohn/work-gh/mrva/mrvaagent
CODEQL_VERSION=latest


# === Bootstrap base system ===
echo "[1/6] Bootstrapping Ubuntu into $CHROOT_ROOT"
sudo debootstrap --variant=minbase bookworm "$CHROOT_ROOT" http://deb.debian.org/debian

# === Install base packages ===
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

# === Install CodeQL CLI ===
cd /Users/hohn/work-gh/mrva/mrva-docker/lima
echo "[3/6] Installing CodeQL CLI"
TAG=v2.21.3
# # update codeql version via
# TAG=$(curl -s https://api.github.com/repos/github/codeql-cli-binaries/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
echo "  -> Using CodeQL version: $TAG"
mkdir -p "$CHROOT_ROOT/opt"
curl -L "https://github.com/github/codeql-cli-binaries/releases/download/$TAG/codeql-linux64.zip" -o /tmp/codeql.zip
sudo unzip -q /tmp/codeql.zip -d "$CHROOT_ROOT/opt"
# optional:
# rm /tmp/codeql.zip

# === Set CodeQL env vars ===
echo "[4/6] Adding CodeQL environment to chroot"
sudo tee "$CHROOT_ROOT/etc/profile.d/codeql.sh" > /dev/null <<EOF
export CODEQL_CLI_PATH=/opt/codeql/codeql
export CODEQL_JAVA_HOME=/usr
EOF

# === machine setup: go ===
cd /usr/local
sudo curl -LO https://go.dev/dl/go1.22.0.linux-arm64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -xzf go1.22.0.linux-arm64.tar.gz
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
sudo apt remove -y golang
# ensure correct version is first:
export PATH=/usr/local/go/bin:$PATH

# === Build Go binary ===
echo "[5/6] Building mrvaagent Go binary"
cd "$GO_SRC_DIR"
export GO111MODULE=on CGO_ENABLED=0 
go build -o mrvaagent-binary

echo "  -> Installing binary to chroot"
sudo cp mrvaagent-binary "$CHROOT_ROOT/usr/local/bin/mrvaagent"

# === Install minimal entrypoint ===
echo "[6/6] Installing entrypoint script"
sudo tee "$CHROOT_ROOT/usr/local/bin/entrypoint.sh" > /dev/null <<'EOF'
#!/bin/bash
set -e
echo "Starting agent..."
exec /usr/local/bin/mrvaagent
EOF
sudo chmod +x "$CHROOT_ROOT/usr/local/bin/entrypoint.sh"

echo "✅ Agent chroot setup complete at $CHROOT_ROOT"
