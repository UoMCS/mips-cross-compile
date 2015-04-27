#!/bin/bash

export XC_TARGET="mips"
export XC_PREFIX="${HOME}/xc"
export XC_TMP_DIR="${XC_PREFIX}/${XC_TARGET}/tmp"
export PATH="${PATH}:${XC_PREFIX}/bin"

export GNU_BASE_URL="http://ftpmirror.gnu.org"
export SOURCEWARE_BASE_URL="ftp://sourceware.org/pub"

export BINUTILS_VERSION="2.25"
export BINUTILS_FILENAME="binutils-${BINUTILS_VERSION}.tar.gz"
export BINUTILS_URL="${GNU_BASE_URL}/binutils/${BINUTILS_FILENAME}"
export BINUTILS_TARBALL="${XC_TMP_DIR}/${BINUTILS_FILENAME}"
export BINUTILS_SRC_DIR="${XC_TMP_DIR}/binutils-${BINUTILS_VERSION}"
export BINUTILS_BUILD_DIR="${XC_TMP_DIR}/build-binutils"
export BINUTILS_CONFIGURE_OPTIONS=(
  "--prefix=${XC_PREFIX}"
  "--target=${XC_TARGET}"
  "--disable-multilib"
  "--disable-nls"
)

export GCC_LANGS="c"
export GCC_VERSION="4.9.2"
export GCC_FILENAME="gcc-${GCC_VERSION}.tar.gz"
export GCC_URL="${GNU_BASE_URL}/gcc/gcc-${GCC_VERSION}/${GCC_FILENAME}"
export GCC_TARBALL="${XC_TMP_DIR}/${GCC_FILENAME}"
export GCC_SRC_DIR="${XC_TMP_DIR}/gcc-${GCC_VERSION}"
export GCC_BUILD_DIR="${XC_TMP_DIR}/build-gcc"
export GCC_CONFIGURE_OPTIONS_PASS_ONE=(
  "--prefix=${XC_PREFIX}"
  "--target=${XC_TARGET}"
  "--disable-multilib"
  "--disable-nls"
  "--enable-languages=${GCC_LANGS}"
  "--without-headers"
  "--with-newlib"
)

export GCC_CONFIGURE_OPTIONS_PASS_TWO=(
  "--prefix=${XC_PREFIX}"
  "--target=${XC_TARGET}"
  "--disable-multilib"
  "--disable-nls"
  "--enable-languages=${GCC_LANGS}"
  "--with-newlib"
)

export MPFR_VERSION="3.1.2"
export MPFR_FILENAME="mpfr-${MPFR_VERSION}.tar.xz"
export MPFR_URL="${GNU_BASE_URL}/mpfr/${MPFR_FILENAME}"
export MPFR_TARBALL="${XC_TMP_DIR}/${MPFR_FILENAME}"
export MPFR_SRC_DIR="${XC_TMP_DIR}/mpfr-${MPFR_VERSION}"

export MPC_VERSION="1.0.3"
export MPC_FILENAME="mpc-${MPC_VERSION}.tar.gz"
export MPC_URL="${GNU_BASE_URL}/mpc/${MPC_FILENAME}"
export MPC_TARBALL="${XC_TMP_DIR}/${MPC_FILENAME}"
export MPC_SRC_DIR="${XC_TMP_DIR}/mpc-${MPC_VERSION}"

export GMP_VERSION="6.0.0"
export GMP_VERSION_MINOR="a"
export GMP_FILENAME="gmp-${GMP_VERSION}${GMP_VERSION_MINOR}.tar.xz"
export GMP_URL="${GNU_BASE_URL}/gmp/${GMP_FILENAME}"
export GMP_TARBALL="${XC_TMP_DIR}/${GMP_FILENAME}"
export GMP_SRC_DIR="${XC_TMP_DIR}/gmp-${GMP_VERSION}"

export NEWLIB_VERSION="2.2.0-1"
export NEWLIB_FILENAME="newlib-${NEWLIB_VERSION}.tar.gz"
export NEWLIB_URL="${SOURCEWARE_BASE_URL}/newlib/${NEWLIB_FILENAME}"
export NEWLIB_TARBALL="${XC_TMP_DIR}/${NEWLIB_FILENAME}"
export NEWLIB_SRC_DIR="${XC_TMP_DIR}/newlib-${NEWLIB_VERSION}"
export NEWLIB_BUILD_DIR="${XC_TMP_DIR}/build-newlib"
export NEWLIB_CONFIGURE_OPTIONS=(
  "--prefix=${XC_PREFIX}"
  "--target=${XC_TARGET}"
  "--disable-multilib"
  "--disable-nls"
)
