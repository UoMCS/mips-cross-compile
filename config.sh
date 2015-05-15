#!/bin/bash

# Target architecture for the toolchain. Depending on the architecture, you
# may need all parts of the triplet (e.g. for a Raspberry Pi you should set
# XC_TARGET to "arm-unknown-linux-gnueabihf").
export XC_TARGET="mips-elf"
export XC_KERNEL_TARGET="mips"

# Prefix to use for downloading and building the toolchain, as well as the
# destination directory for the final binaries.
# This prefix must not contain spaces, otherwise the build will fail (this is
# due to the binutils makefiles and nothing to do with this build script).
# Do not specify an existing directory for the prefix as it will be deleted
# each time you do a full rebuild.
export XC_PREFIX="${HOME}/xc"

# Don't edit these configuration variables.
export XC_TMP_DIR="${XC_PREFIX}/${XC_TARGET}/tmp"
export PATH="${XC_PREFIX}/bin:${PATH}"

# GNU (binutils, GCC + dependencies) and Sourceware (newlib) URLs. You can
# change these to a local mirror if required.
export GNU_BASE_URL="http://ftpmirror.gnu.org"
export SOURCEWARE_BASE_URL="ftp://sourceware.org/pub"
export KERNEL_BASE_URL="https://www.kernel.org/pub/linux/kernel"
export GCC_BASE_URL="ftp://gcc.gnu.org/pub/gcc"

# Version numbers for the relevant components of the toolchain. Not all
# version combinations have been tested. Unless you need a feature in
# a later version, do not edit these options.
export BINUTILS_VERSION="2.25"

# Kernel headers are required for glibc
# Generally it is best to choose the latest stable release
export KERNEL_VERSION_MAJOR="4"
export KERNEL_VERSION_MINOR="0.3"
export KERNEL_VERSION="${KERNEL_VERSION_MAJOR}.${KERNEL_VERSION_MINOR}"

export GLIBC_VERSION="2.21"

# The GCC version number should be in the same minor series as your host
# compiler. For example, if your host has GCC 4.9.1, you can probably set
# GCC_VERSION to the latest version of the 4.9.x series, but you should not
# set it to 5.x.
export GCC_VERSION="4.9.2"
export GCC_LANGS="c,c++"

export MPFR_VERSION="3.1.2"
export MPC_VERSION="1.0.3"

export GMP_VERSION="6.0.0"
export GMP_VERSION_MINOR="a"

export GLOBAL_CONFIGURE_OPTIONS=(
  "--prefix=${XC_PREFIX}"
  "--target=${XC_TARGET}"
  "--disable-multilib"
  "--disable-werror"
  #"--disable-threads"
)

# You should not need to edit any of the following variables unless the build
# process fails.
export BINUTILS_FILENAME="binutils-${BINUTILS_VERSION}.tar.bz2"
export BINUTILS_URL="${GNU_BASE_URL}/binutils/${BINUTILS_FILENAME}"
export BINUTILS_TARBALL="${XC_TMP_DIR}/${BINUTILS_FILENAME}"
export BINUTILS_SRC_DIR="${XC_TMP_DIR}/binutils-${BINUTILS_VERSION}"
export BINUTILS_BUILD_DIR="${XC_TMP_DIR}/build-binutils"
export BINUTILS_CONFIGURE_OPTIONS=(

)

BINUTILS_CONFIGURE_OPTIONS+=(${GLOBAL_CONFIGURE_OPTIONS[*]})

export KERNEL_FILENAME="linux-${KERNEL_VERSION}.tar.xz"
export KERNEL_URL="${KERNEL_BASE_URL}/v${KERNEL_VERSION_MAJOR}.x/${KERNEL_FILENAME}"
export KERNEL_TARBALL="${XC_TMP_DIR}/${KERNEL_FILENAME}"
export KERNEL_SRC_DIR="${XC_TMP_DIR}/linux-${KERNEL_VERSION}"
export KERNEL_MAKE_OPTIONS=(
  "ARCH=${XC_KERNEL_TARGET}"
  "INSTALL_HDR_PATH=${XC_PREFIX}"
  "headers_install"
)

export GLIBC_FILENAME="glibc-${GLIBC_VERSION}.tar.xz"
export GLIBC_URL="${GNU_BASE_URL}/glibc/${GLIBC_FILENAME}"
export GLIBC_TARBALL="${XC_TMP_DIR}/${GLIBC_FILENAME}"
export GLIBC_SRC_DIR="${XC_TMP_DIR}/glibc-${GLIBC_VERSION}"
export GLIBC_BUILD_DIR="${XC_TMP_DIR}/build-glibc"
export GLIBC_CONFIGURE_OPTIONS=(
  "--build=${MACHTYPE}"
  "--host=${XC_TARGET}"
  "--with-headers=${XC_PREFIX}/${XC_TARGET}/include"
  "libc_cv_forced_unwind=yes"
)

GLIBC_CONFIGURE_OPTIONS+=(${GLOBAL_CONFIGURE_OPTIONS[*]})

export GCC_FILENAME="gcc-${GCC_VERSION}.tar.gz"
export GCC_URL="${GNU_BASE_URL}/gcc/gcc-${GCC_VERSION}/${GCC_FILENAME}"
export GCC_TARBALL="${XC_TMP_DIR}/${GCC_FILENAME}"
export GCC_SRC_DIR="${XC_TMP_DIR}/gcc-${GCC_VERSION}"
export GCC_BUILD_DIR="${XC_TMP_DIR}/build-gcc"

export GCC_CONFIGURE_OPTIONS=(
  "--enable-languages=${GCC_LANGS}"
)

GCC_CONFIGURE_OPTIONS+=(${GLOBAL_CONFIGURE_OPTIONS[*]})

export MPFR_FILENAME="mpfr-${MPFR_VERSION}.tar.xz"
export MPFR_URL="${GNU_BASE_URL}/mpfr/${MPFR_FILENAME}"
export MPFR_TARBALL="${XC_TMP_DIR}/${MPFR_FILENAME}"
export MPFR_SRC_DIR="${XC_TMP_DIR}/mpfr-${MPFR_VERSION}"

export MPC_FILENAME="mpc-${MPC_VERSION}.tar.gz"
export MPC_URL="${GNU_BASE_URL}/mpc/${MPC_FILENAME}"
export MPC_TARBALL="${XC_TMP_DIR}/${MPC_FILENAME}"
export MPC_SRC_DIR="${XC_TMP_DIR}/mpc-${MPC_VERSION}"

export GMP_FILENAME="gmp-${GMP_VERSION}${GMP_VERSION_MINOR}.tar.xz"
export GMP_URL="${GNU_BASE_URL}/gmp/${GMP_FILENAME}"
export GMP_TARBALL="${XC_TMP_DIR}/${GMP_FILENAME}"
export GMP_SRC_DIR="${XC_TMP_DIR}/gmp-${GMP_VERSION}"
