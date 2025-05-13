#!/bin/bash
set -e

# Format partitions and create labels
mkfs.fat -F32 /dev/nvme0n1p1
fatlabel /dev/nvme0n1p1 BOOT
mkfs.btrfs -f /dev/nvme0n1p2 -L ROOT

# Mount root subvolume
mount -o autodefrag,compress=zstd /dev/nvme0n1p2 /mnt

# Mount the EFI partition
mount /dev/nvme0n1p1 /mnt/boot

# Install base system packages
pacstrap -K /mnt \
  base base-devel linux linux-firmware \
  zsh \
  doas btrfs-progs \
  refind efibootmgr \
  pipewire pipewire-alsa pipewire-pulse wireplumber alsa-utils \
  networkmanager \
  intel-ucode sof-firmware \
  git neovim

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Set executable permissions for post-install scripts
chmod +x chroot.sh
chmod +x luke.sh
cp chroot.sh /mnt/chroot.sh
cp luke.sh /mnt/luke.sh

# Chroot into the new system
arch-chroot /mnt /chroot.sh