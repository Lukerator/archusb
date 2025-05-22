#!/bin/sh
set -e

touch /etc/s6/adminsv/default/contents.d/dbus
touch /etc/s6/adminsv/default/contents.d/NetworkManager
touch /etc/s6/adminsv/default/contents.d/ly
echo "tty = 7" >> /etc/ly/config.ini
rm -rf /etc/s6/rc/compiled-*
s6-db-reload

ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ro_RO.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Luke-PC" > /etc/hostname

passwd

useradd -m -G wheel,audio,video,network,storage,power,lp,input -c "Luke" -s /usr/bin/nu luke
passwd luke

echo "permit nopass luke cmd /usr/bin/halt" > /etc/doas.conf
echo "permit nopass luke cmd /usr/bin/reboot" > /etc/doas.conf
echo "permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} luke" > /etc/doas.conf

pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-7.0.0.r6.gc685ae6-3-x86_64.pkg.tar.zst'

rm /etc/pacman.conf
mv /pacman.conf /etc/pacman.conf

refind-install
echo "COPY THIS: root=LABEL=ROOT rw noatime nodiratime autodefrag compress=zstd quiet splash" >> /boot/refind_linux.conf
nvim /boot/refind_linux.conf

cp luke.sh /home/luke/luke.sh
cd /home/luke

su luke -s /usr/bin/bash
