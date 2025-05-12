#!/bin/bash
set -e

ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc

# Enable locales
rm -f /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ro_RO.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen

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

systemctl enable NetworkManage

refind-install

# Pause so you can edit manually
echo "Edit refind_linux.conf if needed. Add 'root=LABEL=ROOT rw splash'"
echo "Don't forget to run luke.sh!!"

su luke -s /usr/bin/bash -c "cd && ~/luke.sh && rm ~/luke.sh"