#!/bin/bash
set -e

mkfs.fat -F32 /dev/nvme0n1p1
fatlabel /dev/nvme0n1p1 BOOT
mkfs.btrfs -f /dev/nvme0n1p2 -L ROOT

mount -o noatime,compress=zstd,autodefrag /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot

pacstrap -K /mnt \
  base base-devel linux linux-firmware \
  zsh \
  doas btrfs-progs \
  refind efibootmgr \
  pipewire pipewire-alsa pipewire-pulse wireplumber alsa-utils \
  networkmanager \
  intel-ucode sof-firmware \
  git neovim

genfstab -L /mnt >> /mnt/etc/fstab

chmod +x chroot.sh
chmod +x luke.sh
cp chroot.sh /mnt/chroot.sh
cp luke.sh /mnt/luke.sh

arch-chroot /mnt /chroot.zh