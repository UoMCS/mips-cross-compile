# MIPS Cross Compile

Cross compiling the GNU toolchain for MIPS on x86_64.

To build the toolchain, first edit any configuration options in `config.sh`
(e.g. to change the installation directory) and then run:

```
FULL_REBUILD=1 bash ./build.sh
```

The build script will start from scratch, purging any existing toolchain. Be
sure this is what you want *before* you start the build process.

## Requirements

This software has only been tested on x86_64 systems running a recent version
of Linux. It will not work on Cygwin due to its lack of support for `stat64`
(see the Cygwin FAQ for full details), which is used in glibc. It may work on
OS X, but you will have to install a host version of GCC and change environment
variables such as `CC`, otherwise clang will be used for compiling and linking
and it cannot bootstrap GCC.
