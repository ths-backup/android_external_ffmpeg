#!/bin/bash


NDK=/data/android/android-ndk-r5c
PLATFORM=$NDK/platforms/android-8/arch-arm/
PREBUILT=$NDK/toolchains/arm-eabi-4.4.0/prebuilt/linux-x86

NATIVE_PATH=.
rm -r $NATIVE_PATH/android
mkdir $NATIVE_PATH/android

CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"


SO_PATH=$NATIVE_PATH/android/$CPU
mkdir $SO_PATH

cp config_neon.h config.h
cp config_neon.mak config.mak
make clean
make -j8

$PREBUILT/bin/arm-eabi-ar d libavcodec/libavcodec.a inverse.o

$PREBUILT/bin/arm-eabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $SO_PATH/libffmpeg_dice.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a  libswscale/libswscale.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-eabi/4.4.0/libgcc.a

$PREBUILT/bin/arm-eabi-strip $SO_PATH/libffmpeg_dice.so
