#!/bin/bash
set -e

dnl Configuration values for the server chroot
define(`CHROOT_ROOT', `/srv/mrva/server-root')
define(`GO_SRC_DIR', `/Users/hohn/work-gh/mrva/mrvaserver')
define(`GO_VERSION', `1.22.0')
define(`CODEQL_TAG', `v2.21.3')

CHROOT_BOOTSTRAP(CHROOT_ROOT)
CHROOT_INSTALL_BASE_PACKAGES(CHROOT_ROOT)
CHROOT_INSTALL_CODEQL(CHROOT_ROOT, CODEQL_TAG)
CHROOT_SET_CODEQL_ENV(CHROOT_ROOT)
INSTALL_GO_TOOLCHAIN(GO_VERSION)
BUILD_AND_COPY_GO_BINARY(CHROOT_ROOT, GO_SRC_DIR, mrvaserver)
