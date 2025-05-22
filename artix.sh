#!/bin/sh
fstabgen -L /mnt >> /mnt/etc/fstab

chmod +x ./chroot-artix.sh
chmod +x ./luke.sh
cp chroot-artix.sh /mnt/chroot.sh
cp luke.sh /mnt/luke.sh

cp ./pacman.conf /mnt/pacman.conf

artix-chroot /mnt
