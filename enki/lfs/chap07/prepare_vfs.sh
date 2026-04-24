#/bin/bash

echo '****' Preparing Virtual Kernel File Systems

if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: root"
        exit 255
fi

LFS=/mnt/lfs

if [ ! -d /mnt/lfs/dev ]; then
    mkdir -pv $LFS/{dev,proc,sys,run}
fi

if [ ! -d /mnt/lfs/proc/meminfo ]; then
    mount -v --bind /dev $LFS/dev

    mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
    mount -vt proc proc $LFS/proc
    mount -vt sysfs sysfs $LFS/sys
    mount -vt tmpfs tmpfs $LFS/run

    if [ -h $LFS/dev/shm ]; then
      install -v -d -m 1777 $LFS$(realpath /dev/shm)
    else
      mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
    fi
fi
