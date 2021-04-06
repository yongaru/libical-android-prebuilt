#!/bin/bash



export API=21 # 안드로이드 API 버전
# -DANDROID_ABI=$ABI \
# -DANDROID_NATIVE_API_LEVEL=$MINSDKVERSION \

ORI_PWD=$PWD

build_libical(){
    OUT_DIR=$ORI_PWD/../libs/android/libical/$TARGET_ABI # 빌드 라이브러리 경로
    TMP_DIR=$ORI_PWD/../tmp/libical/$TARGET_ABI
    # 안드로이드 빌드 환경 임포트
    source  ./env-ndk.sh

    rm -rf $TMP_DIR
    # 빌드 임시 경로 및 결과물 디렉토리 생성
    mkdir -p $TMP_DIR
    mkdir -p $OUT_DIR

    # 빌드 임시 경로로 이동
    cd $TMP_DIR

    # cmake cxx 빌드 못한다고 처음 오류 남.. 두번쩨 정상 빌드됨..
    # cmake
    echo 빌드1

# =$TOOLCHAIN/bin/$TARGET$API-clang++
# /mnt/j/platforms/sdk-linux/cmake/3.10.2.4988404/bin/cmake
    # cmake ../../../libs-src/libical \
    #     -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake  \
    #     -DICAL_GLIB=False \
    #     -DICAL_GLIB_VAPI=False \
    #     -DWITH_CXX_BINDINGS=True \
    #     -DANDROID_ABI=$TARGET_ABI \
    #     -DANDROID_NATIVE_API_LEVEL=$API \
    #     -DANDROID_TOOLCHAIN=clang \
    #     -DUSE_BUILTIN_TZDATA=True \
    #     -DSTATIC_ONLY=True \
    #     -DCMAKE_CXX_COMPILER=$CXX \
    #     -DCMAKE_INSTALL_PREFIX=$OUT_DIR 



    echo 빌드2
#        -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake  \
    cmake ../../../libs-src/libical \
        -DCMAKE_TOOLCHAIN_FILE=../../../libs-src/libical/cmake/Toolchain-android.cmake   \
        -DICAL_GLIB=False \
        -DICAL_GLIB_VAPI=False \
        -DWITH_CXX_BINDINGS=True \
        -DANDROID_ABI=$TARGET_ABI \
        -DANDROID_NATIVE_API_LEVEL=$API \
        -DANDROID_TOOLCHAIN=clang \
        -DUSE_BUILTIN_TZDATA=True \
        -DSTATIC_ONLY=True \
        -DCMAKE_INSTALL_PREFIX=$OUT_DIR  \
        -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
        -DPERL_EXECUTABLE=/usr/bin/perl

        # -DCMAKE_CXX_COMPILER=$CXX \
        # -DCMAKE_C_COMPILER=$CXX \

#        -DSTATIC_ONLY=True \
#        -DUSE_BUILTIN_TZDATA=True \

    echo 빌드3
    make -j 8 &&  make install


    cd $ORI_PWD
}

for TARGET_ABI in arm64-v8a  x86 x86_64  armeabi-v7a
# for TARGET_ABI in x86_64
do
    export TARGET_ABI
    export ANDROID_ABI=$TARGET_ABI
#    source  ./env-ndk.sh
    build_libical
done





