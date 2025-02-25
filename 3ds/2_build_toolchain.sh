#!/bin/bash

# abort on error
set -e

export WORKSPACE=$PWD

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/../shared/import.sh

# Override ICU version to 59.2
source $SCRIPT_DIR/packages.sh

# Number of CPU
nproc=$(nproc)

# Use ccache?
test_ccache

# Toolchain available?
if [[ -z $DEVKITPRO || -z $DEVKITARM ]]; then
	echo "Setup devkitARM properly. \$DEVKITPRO and \$DEVKITARM need to be set."
	exit 1
fi

if [ ! -f .patches-applied ]; then
	echo "Patching libraries"

	patches_common

	# Fix mpg123
	(cd $MPG123_DIR
		patch -Np1 < $SCRIPT_DIR/../shared/extra/mpg123.patch
		autoreconf -fi
	)

	# Fix icu build
	perl -pi -e 's/xlocale/locale/' icu/source/i18n/digitlst.cpp
	cp -rup icu icu-native
	patch -Np0 < $SCRIPT_DIR/icu59-3ds.patch

	touch .patches-applied
fi

cd $WORKSPACE

echo "Preparing toolchain"

export PATH=$DEVKITARM/bin:$PATH

export PLATFORM_PREFIX=$WORKSPACE
export TARGET_HOST=arm-none-eabi
unset PKG_CONFIG_PATH
export PKG_CONFIG_LIBDIR=$PLATFORM_PREFIX/lib/pkgconfig
export MAKEFLAGS="-j${nproc:-2}"

function set_build_flags {
	export CC="$TARGET_HOST-gcc"
	export CXX="$TARGET_HOST-g++"
	if [ "$ENABLE_CCACHE" ]; then
		export CC="ccache $CC"
		export CXX="ccache $CXX"
	fi
	ARCH_FLAGS="-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -mword-relocations"
	export CFLAGS="-g0 -O2 $ARCH_FLAGS -ffunction-sections -fdata-sections"
	export CXXFLAGS="$CFLAGS"
	export CPPFLAGS="-D_3DS -I$PLATFORM_PREFIX/include -I$DEVKITPRO/libctru/include"
	export LDFLAGS="$ARCH_FLAGS -L$PLATFORM_PREFIX/lib -L$DEVKITPRO/libctru/lib"
	export LIBS="-lctru"
	export CMAKE_SYSTEM_NAME="Generic"
}

install_lib_icu_native

set_build_flags

install_lib_zlib
install_lib $LIBPNG_DIR $LIBPNG_ARGS
install_lib_cmake $FREETYPE_DIR $FREETYPE_ARGS -DFT_DISABLE_HARFBUZZ=ON
#install_lib_cmake $HARFBUZZ_DIR $HARFBUZZ_ARGS
#install_lib_cmake $FREETYPE_DIR $FREETYPE_ARGS -DFT_DISABLE_HARFBUZZ=OFF
install_lib $PIXMAN_DIR $PIXMAN_ARGS
install_lib_cmake $EXPAT_DIR $EXPAT_ARGS
install_lib $LIBOGG_DIR $LIBOGG_ARGS
install_lib $TREMOR_DIR $TREMOR_ARGS
install_lib_mpg123
install_lib_cmake $LIBXMP_LITE_DIR $LIBXMP_LITE_ARGS
install_lib $SPEEXDSP_DIR $SPEEXDSP_ARGS
install_lib_cmake $WILDMIDI_DIR $WILDMIDI_ARGS
install_lib $OPUS_DIR $OPUS_ARGS
install_lib $OPUSFILE_DIR $OPUSFILE_ARGS
install_lib_cmake $FLUIDLITE_DIR $FLUIDLITE_ARGS
install_lib_cmake $FMT_DIR $FMT_ARGS
install_lib_icu_cross
install_lib_liblcf
