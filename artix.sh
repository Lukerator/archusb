#!/bin/sh
genfstab -L /mnt >> /mnt/etc/fstab

chmod +x ./chroot-artix.sh
chmod +x ./luke.sh
cp chroot-artix.sh /mnt/chroot.sh
cp luke.sh /mnt/luke.sh

rm /mnt/etc/pacman.conf
cp ./pacman.conf /mnt/etc/pacman.conf

artix-chroot /mnt
