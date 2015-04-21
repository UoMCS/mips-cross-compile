#!/bin/bash

# Enable debugging options
set -u
set -e

source ./config.sh

build_binutils()
{
  local pkg_name="binutils"
  local compression="bz2"
  local filename="${pkg_name}-${XC_BINUTILS_VERSION}.tar.${compression}"
  local src_url="${GNU_BASE_URL}/${pkg_name}/${filename}"
  local build_path="${XC_BUILD_DIR}/build-${pkg_name}"
  local src_file="${XC_BUILD_DIR}/${filename}"
  local src_relative_path="${pkg_name}-${XC_BINUTILS_VERSION}"
  local src_absolute_path="${XC_BUILD_DIR}/${src_relative_path}"

  local configure_options=(
    "--prefix=${XC_PREFIX}"
    "--target=${XC_TARGET}"
    "--disable-multilib"
  )

  # Fetch the source tarball if it doesn't already exist
  if [ ! -f ${src_file} ]; then
    cd ${XC_BUILD_DIR}
    wget ${src_url}
  fi

  # Remove the build path as we are starting from scratch
  if [ -d ${build_path} ]; then
    rm -rf ${build_path}
  fi

  # Remove the source path if it exists
  if [ -d ${src_absolute_path} ]; then
    rm -rf ${src_absolute_path}
  fi

  cd ${XC_BUILD_DIR}
  tar xf ${src_file}

  mkdir ${build_path}
  cd ${build_path}
  ../${src_relative_path}/configure ${configure_options[*]}
  make
  make install
}

build_gcc_pass_one()
{
  local pkg_name="gcc"
  local compression="gz"
  local filename="${pkg_name}-${XC_GCC_VERSION}.tar.${compression}"
  local src_url="${GNU_BASE_URL}/${pkg_name}/${pkg_name}-${XC_GCC_VERSION}/${filename}"
  local build_path="${XC_BUILD_DIR}/build-${pkg_name}"
  local src_file="${XC_BUILD_DIR}/${filename}"
  local src_relative_path="${pkg_name}-${XC_GCC_VERSION}"
  local src_absolute_path="${XC_BUILD_DIR}/${src_relative_path}"

  local configure_options=(
    "--prefix=${XC_PREFIX}"
    "--target=${XC_TARGET}"
    "--enable-languages=${XC_GCC_LANGS}"
    "--disable-multilib"
  )

  # Fetch the source tarball if it doesn't already exist
  if [ ! -f ${src_file} ]; then
    cd ${XC_BUILD_DIR}
    wget ${src_url}
  fi

  # Remove the build path as we are starting from scratch
  if [ -d ${build_path} ]; then
    rm -rf ${build_path}
  fi

  # Remove the source path if it exists
  if [ -d ${src_absolute_path} ]; then
    rm -rf ${src_absolute_path}
  fi

  cd ${XC_BUILD_DIR}
  tar xf ${src_file}

  get_mpfr
  cd ${src_absolute_path}
  ln -s ../mpfr-${XC_MPFR_VERSION} mpfr

  get_gmp
  cd ${src_absolute_path}
  ln -s ../gmp-${XC_GMP_VERSION} gmp

  get_mpc
  cd ${src_absolute_path}
  ln -s ../mpc-${XC_MPC_VERSION} mpc

  mkdir ${build_path}
  cd ${build_path}
  ../${src_relative_path}/configure ${configure_options[*]}
  make all-gcc
}

get_mpfr()
{
  local pkg_name="mpfr"
  local compression="xz"
  local filename="${pkg_name}-${XC_MPFR_VERSION}.tar.${compression}"
  local src_url="${GNU_BASE_URL}/${pkg_name}/${filename}"
  local src_file="${XC_BUILD_DIR}/${filename}"
  local src_relative_path="${pkg_name}-${XC_MPFR_VERSION}"
  local src_absolute_path="${XC_BUILD_DIR}/${src_relative_path}"

  # Fetch the source tarball if it doesn't already exist
  if [ ! -f ${src_file} ]; then
    cd ${XC_BUILD_DIR}
    wget ${src_url}
  fi

  # Remove the source path if it exists
  if [ -d ${src_absolute_path} ]; then
    rm -rf ${src_absolute_path}
  fi

  cd ${XC_BUILD_DIR}
  tar xf ${src_file}
}

get_gmp()
{
  local pkg_name="gmp"
  local compression="xz"
  local filename="${pkg_name}-${XC_GMP_VERSION}${XC_GMP_VERSION_MINOR}.tar.${compression}"
  local src_url="${GNU_BASE_URL}/${pkg_name}/${filename}"
  local src_file="${XC_BUILD_DIR}/${filename}"
  local src_relative_path="${pkg_name}-${XC_GMP_VERSION}"
  local src_absolute_path="${XC_BUILD_DIR}/${src_relative_path}"

  # Fetch the source tarball if it doesn't already exist
  if [ ! -f ${src_file} ]; then
    cd ${XC_BUILD_DIR}
    wget ${src_url}
  fi

  # Remove the source path if it exists
  if [ -d ${src_absolute_path} ]; then
    rm -rf ${src_absolute_path}
  fi

  cd ${XC_BUILD_DIR}
  tar xf ${src_file}
}

get_mpc()
{
  local pkg_name="mpc"
  local compression="gz"
  local filename="${pkg_name}-${XC_MPC_VERSION}.tar.${compression}"
  local src_url="${GNU_BASE_URL}/${pkg_name}/${filename}"
  local src_file="${XC_BUILD_DIR}/${filename}"
  local src_relative_path="${pkg_name}-${XC_MPC_VERSION}"
  local src_absolute_path="${XC_BUILD_DIR}/${src_relative_path}"

  # Fetch the source tarball if it doesn't already exist
  if [ ! -f ${src_file} ]; then
    cd ${XC_BUILD_DIR}
    wget ${src_url}
  fi

  # Remove the source path if it exists
  if [ -d ${src_absolute_path} ]; then
    rm -rf ${src_absolute_path}
  fi

  cd ${XC_BUILD_DIR}
  tar xf ${src_file}
}

main()
{
  local current_user=`whoami`

  if [ -d ${XC_PREFIX} ]; then
    rm -rf ${XC_PREFIX}/*
  else
    sudo mkdir -p ${XC_PREFIX}
    sudo chown ${current_user} ${XC_PREFIX}
  fi

  build_binutils
  build_gcc_pass_one
}

main
