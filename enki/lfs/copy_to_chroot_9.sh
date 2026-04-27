#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Script must be run as user: root"
    exit 255
fi

if [ ! -d ./chap09 ]; then
    echo script must be run from below chap09 directory
fi

LFS=/mnt/lfs

source ./system_configuration.sh

cd chap09

cp -vr * $LFS
