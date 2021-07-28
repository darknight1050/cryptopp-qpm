#!/usr/bin/env bash


cd ./cryptopp/TestScripts

#Change this env variable to the number of processors you have
if [ -f /proc/cpuinfo ]; then
	JOBS=$(grep flags /proc/cpuinfo |wc -l)
elif [ ! -z $(which sysctl) ]; then
	JOBS=$(sysctl -n hw.ncpu)
else
	JOBS=2
fi

export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export ANDROID_NDK_ROOT=$NDK
export ANDROID_SDK_ROOT=/usr/lib/android-sdk
export PATH=$TOOLCHAIN/bin:$PATH
export ANDROID_API=28
export ANDROID_ABI=23
export ANDROID_CPU=arm64-v8a
source setenv-android.sh
cd ..
make -j$JOBS -f GNUmakefile-cross distclean
make -j$JOBS -f GNUmakefile-cross static dynamic

cd ..

mkdir ./shared
find ./cryptopp -name \*.h -exec cp {} ./shared \;
cp ./cryptopp/libcryptopp.a ./