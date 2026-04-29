#!/bin/bash


if [ -f /mnt/lfs/etc ]; then
    sudo umount /mnt/lfs
    echo /mnt/lfs unmounted
fi

sudo qemu-system-x86_64 -kernel /boot/vmlinuz-6.18.10-lfs-13.0-systemd  -drive file=/dev/sda,format=raw -append "root=/dev/sda3 console=ttyS0" -nographic
