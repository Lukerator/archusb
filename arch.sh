#!/bin/bash
set -e

mkfs.fat -F32 /dev/nvme0n1p1
fatlabel /dev/nvme0n1p1 BOOT
mkfs.btrfs -f /dev/nvme0n1p2 -L ROOT

mount /dev/nvme0n1p2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
umount /mnt

mount -o noatime,compress=zstd,autodefrag,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{boot,home,snapshots}
mount -o noatime,compress=zstd,autodefrag,subvol=@home /dev/nvme0n1p2 /mnt/home
noatime,compress=zstd,autodefrag,subvol=@snapshots /dev/nvme0n1p2 /mnt/snapshots
mount /dev/nvme0n1p1 /mnt/boot

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
cp luke.sh /mnt/home/luke/luke.sh

arch-chroot /mnt /chroot.zh