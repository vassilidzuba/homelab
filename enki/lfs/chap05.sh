#/bin/bash

echo "Building chapter 5"

if [ "$(whoami)" != "lfs" ]; then
        echo "Script must be run as user: lfs"
        exit 255
fi

mkdir -p -v ~/logs

./chap05/binutils.sh | tee ~/logs/chap05_binutils.log
./chap05/gcc.sh | tee ~/logs/chap05_gcc.log
./chap05/apiheaders.sh | tee ~/logs/chap05_apiheaders.log
./chap05/glibc.sh | tee ~/logs/chap05_glibc.log
./chap05/libstdcpp.sh | tee ~/logs/chap05_libstdcpp.log
