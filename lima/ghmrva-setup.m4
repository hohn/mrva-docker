dnl === ghmrva-setup.m4 ===
dnl $1 -- CHROOT_ROOT: chroot target directory
dnl $2 -- GO_SRC_DIR: Go project source dir on host
dnl $3 -- CODEQL_TAG: codeql release tag
dnl $4 -- GO_VERSION: Go toolchain version
dnl $5 -- BIN_NAME: name of resulting binary

define(`CHROOT_ROOT',   `/srv/mrva/ghmrva-root')dnl
define(`GO_SRC_DIR',    `/Users/hohn/work-gh/mrva/gh-mrva')dnl
define(`CODEQL_TAG',    `v2.21.3')dnl
define(`GO_VERSION',    `1.22.0')dnl
define(`BIN_NAME',      `gh-mrva')dnl

CHROOT_BOOTSTRAP(CHROOT_ROOT)
CHROOT_INSTALL_BASE_PACKAGES(CHROOT_ROOT)
CHROOT_INSTALL_CODEQL(CHROOT_ROOT, CODEQL_TAG)
CHROOT_SET_CODEQL_ENV(CHROOT_ROOT)
INSTALL_GO_TOOLCHAIN(GO_VERSION)
BUILD_AND_COPY_GO_BINARY(CHROOT_ROOT, GO_SRC_DIR, BIN_NAME)
