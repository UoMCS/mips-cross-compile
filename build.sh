#!/bin/bash

set -u
set -e

source ./config.sh

export FULL_REBUILD=${FULL_REBUILD:-}

if [ ! -z ${FULL_REBUILD} ]; then
  echo "You are about to rebuild the entire toolchain from scratch"
  echo "This will remove any changes you have made to the source files"
  echo "and take substantially longer than a partial rebuild"
  read -p "Are you sure this is what you want? (y/n) " confirm
  case $confirm in
    [Nn] ) exit;;
  esac
fi

if [ ! -z ${FULL_REBUILD} ]; then
  # Remove and then recreate prefix directory
  if [ -d ${XC_PREFIX} ]; then
    rm -rf ${XC_PREFIX}
  fi

  mkdir ${XC_PREFIX}
fi

# Create temp directory if it does not already exist
if [ ! -d ${XC_TMP_DIR} ]; then
  mkdir -p ${XC_TMP_DIR}
fi

# 1. Download and build binutils
if [ ! -z ${FULL_REBUILD} ]; then
  # Only download the tarball if it does not exist
  if [ ! -f ${BINUTILS_TARBALL} ]; then
    wget ${BINUTILS_URL} -O ${BINUTILS_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${BINUTILS_SRC_DIR} ]; then
    rm -rf ${BINUTILS_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${BINUTILS_TARBALL}
fi

if [ ! -z ${FULL_REBUILD} ]; then
  # Remove the build directory if it exists
  if [ -d ${BINUTILS_BUILD_DIR} ]; then
    rm -rf ${BINUTILS_BUILD_DIR}
  fi

  mkdir ${BINUTILS_BUILD_DIR}
fi

cd ${BINUTILS_BUILD_DIR}
${BINUTILS_SRC_DIR}/configure ${BINUTILS_CONFIGURE_OPTIONS[*]}
make
make install

# 2. Download and build GCC (first pass)
# 2a) Download and extract GCC
if [ ! -z ${FULL_REBUILD} ]; then
  # Only download the tarball if it does not exist
  if [ ! -f ${GCC_TARBALL} ]; then
    wget ${GCC_URL} -O ${GCC_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${GCC_SRC_DIR} ]; then
    rm -rf ${GCC_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${GCC_TARBALL}


  # 2b) Download and extract MPFR
  # Only download tarball if it does not exist
  if [ ! -f ${MPFR_TARBALL} ]; then
    wget ${MPFR_URL} -O ${MPFR_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${MPFR_SRC_DIR} ]; then
   rm -rf ${MPFR_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${MPFR_TARBALL}

  # Symlink so that GCC build can find the library
  cd ${GCC_SRC_DIR}
  ln -s ../mpfr-${MPFR_VERSION} mpfr

  # 2c) Download and extract MPC
  # Only download tarball if it does not exist
  if [ ! -f ${MPC_TARBALL} ]; then
    wget ${MPC_URL} -O ${MPC_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${MPC_SRC_DIR} ]; then
    rm -rf ${MPC_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${MPC_TARBALL}

  # Symlink so that GCC build can find the library
  cd ${GCC_SRC_DIR}
  ln -s ../mpc-${MPC_VERSION} mpc

  # 2d) Download and extract GMP
  # Only download tarball if it does not exist
  if [ ! -f ${GMP_TARBALL} ]; then
    wget ${GMP_URL} -O ${GMP_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${GMP_SRC_DIR} ]; then
    rm -rf ${GMP_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${GMP_TARBALL}

  # Symlink so that GCC build can find the library
  cd ${GCC_SRC_DIR}
  ln -s ../gmp-${GMP_VERSION} gmp
fi

# 2e) Configure and build GCC (1st pass)
if [ ! -z ${FULL_REBUILD} ]; then
  # Remove the build directory if it exists
  if [ -d ${GCC_BUILD_DIR} ]; then
    rm -rf ${GCC_BUILD_DIR}
  fi

  mkdir ${GCC_BUILD_DIR}
fi

cd ${GCC_BUILD_DIR}
${GCC_SRC_DIR}/configure ${GCC_CONFIGURE_OPTIONS_PASS_ONE[*]}
make all-gcc
make install-gcc

# 3. Download and build newlib
if [ ! -z ${FULL_REBUILD} ]; then
  # Only down the tarball if it does not exist
  if [ ! -f ${NEWLIB_TARBALL} ]; then
    wget ${NEWLIB_URL} -O ${NEWLIB_TARBALL}
  fi

  # Remove the source directory if it exists
  if [ -d ${NEWLIB_SRC_DIR} ]; then
    rm -rf ${NEWLIB_SRC_DIR}
  fi

  cd ${XC_TMP_DIR}
  tar xf ${NEWLIB_TARBALL}

  # Remove the build directory if it exists
  if [ -d ${NEWLIB_BUILD_DIR} ]; then
    rm -rf ${NEWLIB_BUILD_DIR}
  fi

  mkdir ${NEWLIB_BUILD_DIR}
fi

cd ${NEWLIB_BUILD_DIR}
${NEWLIB_SRC_DIR}/configure ${NEWLIB_CONFIGURE_OPTIONS[*]}
make
make install

# 4. Rebuild GCC with newlib
cd ${GCC_BUILD_DIR}
${GCC_SRC_DIR}/configure ${GCC_CONFIGURE_OPTIONS_PASS_TWO[*]}
make all
make install
