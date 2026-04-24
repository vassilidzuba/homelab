#/bin/bash

echo "Building chapter 6"

<if [ "$(whoami)" != "lfs" ]; then
        echo "Script must be run as user: lfs"
        exit 255
fi

mkdir -p -v ~/logs

./chap06/m4.sh | tee ~/logs/chap06_m4.log
./chap06/ncurses.sh | tee ~/logs/chap06_ncurses.log
./chap06/bash.sh | tee ~/logs/chap06_bash.log
./chap06/coreutils.sh | tee ~/logs/chap06_coreutils.log
./chap06/diffutils.sh | tee ~/logs/chap06_diffutils.log
./chap06/file.sh | tee ~/logs/chap06_file.log
./chap06/findutils.sh | tee ~/logs/chap06_findutils.log
./chap06/gawk.sh | tee ~/logs/chap06_gawk.log
./chap06/grep.sh | tee ~/logs/chap06_grep.log
./chap06/gzip.sh | tee ~/logs/chap06_gzip.log
./chap06/make.sh | tee ~/logs/qchap06_make.log
./chap06/patch.sh | tee ~/logs/chap06_patch.log
./chap06/sed.sh | tee ~/logs/chap06_sed.log
./chap06/tar.sh | tee ~/logs/chap06_tar.log
./chap06/xz.sh | tee ~/logs/chap06_xz.log
./chap06/binutils.sh | tee ~/logs/chap06_binutils.log
./chap06/gcc.sh | tee ~/logs/chap06_gcc.log
