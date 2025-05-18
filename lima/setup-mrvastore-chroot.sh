
if [ ! -f "/srv/mrva/mrvastore-root/.bootstrapped" ]; then
    echo "[1/6] Bootstrapping Debian into /srv/mrva/mrvastore-root"
    sudo debootstrap --variant=minbase bookworm "/srv/mrva/mrvastore-root" http://deb.debian.org/debian
    sudo touch "/srv/mrva/mrvastore-root/.bootstrapped"
fi


if [ ! -f "/srv/mrva/mrvastore-root/.packages_installed" ]; then
    echo "[2/6] Installing base packages"
    sudo mount -t proc none "/srv/mrva/mrvastore-root/proc"
    sudo chroot "/srv/mrva/mrvastore-root" bash -c "
    apt-get update &&
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      default-jdk
    "
    sudo umount "/srv/mrva/mrvastore-root/proc"
    sudo touch "/srv/mrva/mrvastore-root/.packages_installed"
fi


if [ ! -f "/srv/mrva/mrvastore-root/usr/local/bin/minio" ]; then
    echo "[3/3] Installing MinIO version RELEASE.2024-06-11T03-13-30Z"
    curl -L "https://dl.min.io/server/minio/release/linux-arm64/archive/minio.RELEASE.2024-06-11T03-13-30Z" \
        -o /tmp/minio
    sudo install -m 755 /tmp/minio /srv/mrva/mrvastore-root/usr/local/bin/minio
    sudo rm /tmp/minio
fi
