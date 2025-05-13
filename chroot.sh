#!/bin/bash
set -e

# Set time zone and hardware clock
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc

# Enable locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ro_RO.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Set system language and keymap
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=ro" > /etc/vconsole.conf
echo "Luke-PC" > /etc/hostname

# Set root password
passwd

# Add user
useradd -m -G wheel,audio,video,network,storage,power,lp,input -c "Luke" -s /usr/bin/zsh luke
passwd luke

# Allow wheel group to use doas
echo "permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel" > /etc/doas.conf

# Enable NetworkManager
systemctl enable NetworkManager

# Install and configure rEFInd
refind-install

# Import key for Chaotic AUR
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

# Install Chaotic AUR keyring and mirror list
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Configure Chaotic AUR repository in pacman.conf
echo "" >> /etc/pacman.conf
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Update system and install paru AUR helper
pacman -Syu --noconfirm paru

# Copy post-install script for user
cp luke.sh /mnt/home/luke/luke.sh

# Run post-install setup for the user
su luke -s /usr/bin/bash -c "cd && ~/luke.sh && rm ~/luke.sh"
