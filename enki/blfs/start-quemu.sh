#!/bin/bash


if [ -d /mnt/lfs/etc ]; then
    sudo umount /mnt/lfs
    echo /mnt/lfs unmounted
fi

sudo qemu-system-x86_64 \
    -kernel /boot/vmlinuz-6.18.10-lfs-13.0-systemd \
    -drive file=/dev/sda,format=raw \
    -append "root=/dev/sda3 console=ttyS0" \
    -nographic \
    -m 4G \
    -object memory-backend-memfd,id=mem,size=4G,share=on \
    -numa node,memdev=mem \
    -chardev socket,id=char0,path=/tmp/vm-share.sock \
    -device vhost-user-fs-pci,chardev=char0,tag=myfs
