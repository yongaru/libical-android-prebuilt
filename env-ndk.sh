#!/bin/bash

# 안드로이드용 NDK 빌드 환경 구성 파일
# 김용일<akira76@gmail.com>

export NDK=/mnt/j/platforms/ndk-linux/android-ndk-r10e # libical 전용
# export NDK=/opt/android-ndk-r21

export ANDROID_NDK_ROOT=$NDK
export ANDROID_NDK_HOME=$NDK
export ANDROID_NDK=$NDK

# export TARGET_ABI=armv7a # arm64-v8a | armv7a | i686 | x86_64
# export API=21 # 안드로이드 API 버전


# 호스트 탐지
dectect_host(){
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     HOST_TAG=linux-x86_64;;
        Darwin*)    HOST_TAG=darwin-x86_64;;
        # CYGWIN*)    export HOST_TAG=Cygwin;;
        # MINGW*)     export HOST_TAG=MinGw;;
        *)          HOST_TAG="UNKNOWN:${unameOut}"
    esac
    echo "$HOST_TAG"
} 

# 툴체인 
setup_toolchain(){
    case "${HOST_TAG}" in
        linux-x86_64*)    TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64;;
        darwin-x86_64*)   TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64;;
        *)                TOOLCHAIN="UNKNOWN:${HOST_TAG}"
    esac
    # echo "$TOOLCHAIN"

    echo "$TOOLCHAIN"
}

# 타겟 툴 셋업
setup_target_tools(){

    case "${TARGET_ABI}" in
        arm64-v8a*) TARGET=aarch64-linux-android;;
        armv7a*)  TARGET=armv7a-linux-androideabi;;
        i686*)    TARGET=i686-linux-android;;
        x86_64*)  TARGET=x86_64-linux-android;;
        *)        TARGET="UNKNOWN:${TARGET_ABI}"
    esac    

    echo "$TARGET"
}

setup_compile_tools(){
    
    if [ "$TARGET" = armv7a-linux-androideabi ]; then
        TOOL_TARGET=arm-linux-androideabi
    else
        TOOL_TARGET=$TARGET
    fi

    export AR=$TOOLCHAIN/bin/$TOOL_TARGET-ar
    export AS=$TOOLCHAIN/bin/$TOOL_TARGET-as
    export LD=$TOOLCHAIN/bin/$TOOL_TARGET-ld
    export RANLIB=$TOOLCHAIN/bin/$TOOL_TARGET-ranlib
    export STRIP=$TOOLCHAIN/bin/$TOOL_TARGET-strip

    export CC=$TOOLCHAIN/bin/$TARGET$API-clang
    export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
 
    export NDK_SYS_ROOT=$TOOLCHAIN/sysroot

    # echo $AR
}

setup_for_openssl(){
    export _ANDROID_NDK="android-ndk-r21"
    export _ANDROID_EABI="arm-linux-androideabi-4.9"
    export _ANDROID_ARCH=armv7a # arm64-v8a armv7a i686 x86_64
    export _ANDROID_API="android-21" #"android-18"

}

# 실행 순서

export HOST_TAG=$(dectect_host)
export TOOLCHAIN=$(setup_toolchain)
export TARGET=$(setup_target_tools)
export PATH=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH


setup_compile_tools

# setup_for_openssl
# openssl



echo ========================
echo TARGET_ABI : $TARGET_ABI
echo API : $API
echo TOOLCHAIN : $TOOLCHAIN
echo HOST_TAG : $HOST_TAG
echo TARGET : $TARGET
echo CC : $CC
echo CXX : $CXX
echo ========================
