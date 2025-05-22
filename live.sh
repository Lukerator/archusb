#!/bin/sh
set -e

echo "Choose system [arch/artix]: "
read -r choice

case "$choice" in
	"arch")
		echo "You chose arch, continue? [y/N]:"
		read -r cont
		case "$cont" in
			y)
				echo "this is a test, you failed"
				exit 0
				;;
			*) exit 0 ;;
		esac
		;;
	"artix")
		echo "You chose artix, continue? [y/N]:"
		read -r cont
		case "$cont" in
			y)
				echo "this is a test, you failed"
				exit 0
				;;
			*) exit 0 ;;
		esac
		;;
	*)
		echo "You chose wrong"
		exit 0
	;;
esac

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47

pacman -Syu

pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-22-1-any.pkg.tar.zst'
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-7.0.0.r6.gc685ae6-3-x86_64.pkg.tar.zst'

echo "" >> /etc/pacman.conf
echo "[cachyos-v4]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/cachyos-v4-mirrorlist" >> /etc/pacman.conf
echo "[cachyos-core-v4]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/cachyos-v4-mirrorlist" >> /etc/pacman.conf
echo "[cachyos-extra-v4]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/cachyos-v4-mirrorlist" >> /etc/pacman.conf
echo "[cachyos]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/cachyos-mirrorlist" >> /etc/pacman.conf
echo "" >> /etc/pacman.conf
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

pacman -Syu gdisk

echo "Make a 512M ef00 partition /dev/nvme0n1p1 and a 8304 partition /dev/nvme0n1p2 with the remaining space"
read -rp "Press any key to continue"

cgdisk /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1 -n BOOT
mkfs.btrfs -f /dev/nvme0n1p2 -L ROOT

mount -o noatime,nodiratime,autodefrag,compress=zstd /dev/nvme0n1p2 /mnt

case "$choice" in
	"arch")
		mount --mkdir /dev/nvme0n1p1 /mnt/boot
		pacstrap -K /mnt \
			base \
			pipewire-pulse wireplumber \
			linux-firmware sof-firmware \
			doas doas-sudo-shim base-devel \
			refind networkmanager intel-ucode \
			linux-cachyos-bore-headers linux-cachyos-bore-nvidia-open \
			nushell git neovim paru ly

		genfstab -L /mnt >> /mnt/etc/fstab

		chmod +x ./chroot-arch.sh
		chmod +x ./luke.sh
		cp chroot-arch.sh /mnt/chroot.sh
		cp luke.sh /mnt/luke.sh

		rm /mnt/etc/pacman.conf
		cp ./pacman.conf /mnt/etc/pacman.conf
		arch-chroot /mnt
		;;
	"artix")
		chmod +x ./artix.sh
		mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi
		basestrap /mnt \
			base s6-base seatd-s6 \
			linux-firmware sof-firmware \
			doas doas-sudo-shim base-devel \
			refind networkmanager-s6 dbus-s6 intel-ucode \
			linux-cachyos-bore-headers linux-cachyos-bore-nvidia-open \
			nushell git neovim paru ly-s6
    fstabgen -L /mnt >> /mnt/etc/fstab

    chmod +x ./chroot-artix.sh
    chmod +x ./luke.sh
    cp chroot-artix.sh /mnt/chroot.sh
    cp luke.sh /mnt/luke.sh

    cp ./pacman.conf /mnt/pacman.conf

    artix-chroot /mnt
		;;
esac
