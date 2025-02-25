#!/bin/bash

# abort on errors
set -e

export WORKSPACE=$PWD

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/../shared/import.sh

msg " [1] Checking devkitA64"

if [[ -z $DEVKITPRO || ! -d "$DEVKITPRO/devkitA64" ]]; then
	echo "Setup devkitA64 properly. \$DEVKITPRO needs to be set."
	exit 1
fi

msg " [2] Downloading generic libraries"

# zlib
rm -rf $ZLIB_DIR
download_and_extract $ZLIB_URL

# libpng
rm -rf $LIBPNG_DIR
download_and_extract $LIBPNG_URL

# freetype
rm -rf $FREETYPE_DIR
download_and_extract $FREETYPE_URL

# harfbuzz
rm -rf $HARFBUZZ_DIR
download_and_extract $HARFBUZZ_URL

# pixman
rm -rf $PIXMAN_DIR
download_and_extract $PIXMAN_URL

# expat
rm -rf $EXPAT_DIR
download_and_extract $EXPAT_URL

# libogg
rm -rf $LIBOGG_DIR
download_and_extract $LIBOGG_URL

# tremor
rm -rf $TREMOR_DIR
download_and_extract $TREMOR_URL

# mpg123
rm -rf $MPG123_DIR
download_and_extract $MPG123_URL

# libxmp-lite
rm -rf $LIBXMP_LITE_DIR
download_and_extract $LIBXMP_LITE_URL

# libsamplerate
# speexdsp is not supported!
rm -rf $LIBSAMPLERATE_DIR
download_and_extract $LIBSAMPLERATE_URL

# wildmidi
rm -rf $WILDMIDI_DIR
download_and_extract $WILDMIDI_URL

# opus
rm -rf $OPUS_DIR
download_and_extract $OPUS_URL

# opusfile
rm -rf $OPUSFILE_DIR
download_and_extract $OPUSFILE_URL

# FluidSynth
rm -rf $FLUIDSYNTH_DIR
download_and_extract $FLUIDSYNTH_URL

# fmt
rm -rf $FMT_DIR
download_and_extract $FMT_URL

# ICU
rm -rf $ICU_DIR
download_and_extract $ICU_URL

# icudata
rm -f $ICUDATA_FILES
download_and_extract $ICUDATA_URL

# icudata
rm -f $ICUDATA69_FILES
download_and_extract $ICUDATA69_URL

# liblcf
rm -rf liblcf
download_liblcf
