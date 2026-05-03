#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=llvm-21.1.8.src
SOURCE=llvm-21.1.8.src.tar.xz
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz
MD5=

run_build () {
    cp $SHAREDDIR/llvm-cmake-21.1.8.src.tar.xz .. &&
    cp $SHAREDDIR/llvm-third-party-21.1.8.src.tar.xz .. &&
    cp $SHAREDDIR/clang-21.1.8.src.tar.xz .. &&
    cp $SHAREDDIR/compiler-rt-21.1.8.src.tar.xz .. &&

    tar -xf ../llvm-cmake-21.1.8.src.tar.xz                              &&
    tar -xf ../llvm-third-party-21.1.8.src.tar.xz                        &&
    sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-21.1.8.src@'          \
        -i CMakeLists.txt                                                &&
    sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-21.1.8.src@' \
        -i cmake/modules/HandleLLVMOptions.cmake &&

    tar -xf ../clang-21.1.8.src.tar.xz -C tools &&
    mv tools/clang-21.1.8.src tools/clang &&

    tar -xf ../compiler-rt-21.1.8.src.tar.xz -C projects    &&
    mv projects/compiler-rt-21.1.8.src projects/compiler-rt &&

    grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/' &&

    sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt &&

    mkdir -v build &&
    cd       build &&

    CC=gcc CXX=g++                               \
    cmake -D CMAKE_INSTALL_PREFIX=/usr           \
          -D CMAKE_SKIP_INSTALL_RPATH=ON         \
          -D LLVM_ENABLE_FFI=ON                  \
          -D CMAKE_BUILD_TYPE=Release            \
          -D LLVM_BUILD_LLVM_DYLIB=ON            \
          -D LLVM_LINK_LLVM_DYLIB=ON             \
          -D LLVM_ENABLE_RTTI=ON                 \
          -D LLVM_TARGETS_TO_BUILD="host;AMDGPU" \
          -D LLVM_BINUTILS_INCDIR=/usr/include   \
          -D LLVM_INCLUDE_BENCHMARKS=OFF         \
          -D CLANG_DEFAULT_PIE_ON_LINUX=ON       \
          -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
          -W no-dev -G Ninja ..                  &&
    ninja
}

run_test () {
    echo test not done this time
}

run_install () {
    sudo ninja install
}

run_all
