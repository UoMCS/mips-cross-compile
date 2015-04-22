#!/bin/bash

# Enable debugging options
set -u
set -e

export XC_PREFIX="/opt/cross"
export XC_BIN="${XC_PREFIX}/bin"
export XC_TARGET="mips-linux"
export XC_KERNEL_TARGET="mips"

export XC_BUILD_DIR="/tmp"

export GNU_BASE_URL="http://ftpmirror.gnu.org"
export LINUX_BASE_URL="https://www.kernel.org/pub/linux/kernel/"

export XC_BINUTILS_VERSION="2.25"
export XC_GCC_VERSION="4.9.2"
export XC_MPFR_VERSION="3.1.2"
export XC_GMP_VERSION="6.0.0"
export XC_GMP_VERSION_MINOR="a"
export XC_MPC_VERSION="1.0.3"
export XC_GLIBC_VERSION="2.21"

export XC_LINUX_VERSION_MAJOR="4"
export XC_LINUX_VERSION_MINOR="0"
export XC_LINUX_VERSION="${XC_LINUX_VERSION_MAJOR}.${XC_LINUX_VERSION_MINOR}"

export XC_GCC_LANGS="c,c++"

# Set PATH so that we don't need to specify full path to each executable
export PATH="${XC_BIN}:${PATH}"
