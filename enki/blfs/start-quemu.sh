#!/bin/bash


if [ -d /mnt/lfs/etc ]; then
    sudo umount /mnt/lfs
    echo /mnt/lfs unmounted
fi

#KERNEL=vmlinuz-6.18.10-lfs-13.0-systemd
KERNEL=vmlinuz-7.0.3-lfs-13.0-systemd

sudo chown vassili/vassili /tmp/vm-share
sudo qemu-system-x86_64 \
    -kernel /boot/$KERNEL \
    -drive file=/dev/sda,format=raw \
    -append "root=/dev/sda3 console=ttyS0" \
    -nographic \
    -m 4G \
    -object memory-backend-memfd,id=mem,size=4G,share=on \
    -numa node,memdev=mem \
    -chardev socket,id=char0,path=/tmp/vm-share.sock \
    -cpu host \
    -enable-kvm \
    -device vhost-user-fs-pci,chardev=char0,tag=myfs \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22
