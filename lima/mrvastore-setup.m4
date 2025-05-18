dnl === mrvastore-setup.m4 ===
dnl $1 -- CHROOT_ROOT: chroot install location
dnl $2 -- MINIO_VERSION: MinIO binary release version (e.g. 2024-06-11T03-13-30Z)

define(`CHROOT_ROOT', `/srv/mrva/mrvastore-root')dnl
define(`MINIO_VERSION', `RELEASE.2024-06-11T03-13-30Z')dnl

CHROOT_BOOTSTRAP(CHROOT_ROOT)
CHROOT_INSTALL_BASE_PACKAGES(CHROOT_ROOT)

dnl Install MinIO server binary
if [ ! -f "CHROOT_ROOT/usr/local/bin/minio" ]; then
    echo "[3/3] Installing MinIO version MINIO_VERSION"
    curl -L "https://dl.min.io/server/minio/release/linux-arm64/archive/minio.MINIO_VERSION" \
        -o /tmp/minio
    sudo install -m 755 /tmp/minio CHROOT_ROOT/usr/local/bin/minio
    sudo rm /tmp/minio
fi
