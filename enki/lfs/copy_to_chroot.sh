#!/bin/bash

LFS=/mnt/lfs

if [ ! -d $LFS/lfsscripts ]; then
    mkdir -v $LFS/lfsscripts
fi


cp ./chap07/create_directories.sh $LFS/lfsscripts
cp ./chap07/create_files.sh $LFS/lfsscripts
cp ./chap07/gettext.sh $LFS/lfsscripts
cp ./chap07/bison.sh $LFS/lfsscripts
cp ./chap07/perl.sh $LFS/lfsscripts
cp ./chap07/python.sh $LFS/lfsscripts
cp ./chap07/texinfo.sh $LFS/lfsscripts
cp ./chap07/util-linux.sh $LFS/lfsscripts
cp ./chap07/cleanup.sh $LFS/lfsscripts
