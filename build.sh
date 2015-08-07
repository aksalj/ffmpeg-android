#!/bin/bash

# Pull ffmpeg source
git submodule init
git submodule update
cd ffmpeg

#Android NDK Location
if [ -z "$NDK_ROOT" ]; then
    echo "Need to set NDK_ROOT"
    exit 1
fi

ANDROID_API=android-9
SYSROOT=${NDK_ROOT}/platforms/${ANDROID_API}/arch-arm
PREBUILT=${NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64
CROSS_PREFIX=${PREBUILT}/bin/arm-linux-androideabi-
ARM_INCLUDE=${SYSROOT}/usr/include
ARM_LIB=${SYSROOT}/usr/lib
PREFIX=$(pwd)/../build
OPTIMIZE_CFLAGS=" -marm -march=armv6 "
ADDITIONAL_CONFIGURE_FLAG=

# mp3lame static installation
MP3LAME=../libmp3lame

./configure \
 --arch=arm \
 --target-os=linux \
 --enable-cross-compile \
 --cross-prefix=${CROSS_PREFIX} \
 --prefix=${PREFIX} \
 --sysroot=${SYSROOT} \
 --extra-cflags=" -I${ARM_INCLUDE} -I${MP3LAME}/include -DANDROID ${OPTIMIZE_CFLAGS}" \
 --extra-ldflags=" -L${ARM_LIB} -L${MP3LAME}/lib" \
 --disable-debug \
 --enable-shared \
 --enable-static \
 --enable-libmp3lame \
 --enable-ffplay \
 --enable-ffprobe \
 --enable-ffserver \
 --enable-avfilter \
 --enable-decoders \
 --enable-demuxers \
 --enable-encoders \
 --enable-filters \
 --enable-indevs \
 --enable-network \
 --enable-parsers \
 --enable-protocols \
 --enable-swscale \
 --enable-gpl \
 --enable-nonfree \
 ${ADDITIONAL_CONFIGURE_FLAG}

make -j
make install

cd ..
