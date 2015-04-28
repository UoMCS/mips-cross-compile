# MIPS Cross Compile

Cross compiling the GNU toolchain for MIPS on x86_64.

To build the toolchain, first edit any configuration options in `config.sh`
(e.g. to change the installation directory) and then run:

```
FULL_REBUILD=1 bash ./build.sh
```

The build script will start from scratch, purging any existing toolchain. Be
sure this is what you want *before* you start the build process.
