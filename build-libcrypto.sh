#!/usr/bin/env bash

(
#Change this env variable to the number of processors you have
if [ -f /proc/cpuinfo ]; then
	JOBS=$(grep flags /proc/cpuinfo |wc -l)
elif [ ! -z $(which sysctl) ]; then
	JOBS=$(sysctl -n hw.ncpu)
else
	JOBS=2
fi

export ANDROID_NDK_ROOT=/c/Development/Tools/android-ndk-r21e
export ANDROID_SDK_ROOT=/
export PATH=$PATH:$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/windows-x86_64/bin
echo $PATH
export ANDROID_API=28
export ANDROID_ABI=23
export ANDROID_CPU=arm64-v8a

source setenv-android.sh

cd ./cryptopp
make -j$JOBS -f GNUmakefile-cross distclean
make -j$JOBS -f GNUmakefile-cross static
cd ..

mkdir ./shared
find ./cryptopp -name \*.h -exec cp {} ./shared \;
cp ./cryptopp/libcryptopp.a ./

)