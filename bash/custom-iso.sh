#!/bin/bash

# https://wiki.archlinux.org/index.php/Remastering_the_Install_ISO#Manually

echo "Work in porgress" && exit

### dependencies
libisoburn (cdrkit)
wget
squashfs-tools
arch-install-scripts

### preparation ###
wget [iso image]
mkdir /mnt/[mountpoint]
mount -t iso9660 -o loop [iso] /mnt/[mointpoint]
cp -av /mnt/[mountpoint] [target path]/[target dir]

### x86_64 ###
cd [target path]/[target dir]/arch/[arch]
unsquashfs airootfs.sfs

mkdir mnt
mount -o loop squashfs-root/airootfs.img mnt

arch-chroot mnt /bin/bash #prepend 'setarch i686' for 32bit

### inside chroot ###
export PS1="$(tput setaf 1)[x86_64]$(tput sgr0)${PS1}"
echo KEYMAP=de-latin1-nodeadkeys > /etc/vconsole.conf
-- edit /etc/locale.gen (de_DE.UTF-8, de_DE@euro, en_US.UTF-8)
locale-gen
echo -e "LANG=de_DE.UTF-8\nLANGUAGE=de_DE:de:en_US:en\nLC_COOLLATE=C" > /etc/locale.conf
[[ -f /etc/localtime ]] && rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
pacman-key --init
pacman-key --populate archlinux
LINK='https://www.archlinux.org/mirrorlist/?country=DE&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on'
wget -O - "${LINK}" | sed 's/#S/S/g' > /etc/pacman.d/mirrorlist

dirmngr</dev/null
# x86_64 only: multilib in pacman.conf
# 'Color' in pacman.conf entkommentieren
# infinitaly repo eintragen (+ multilib bei x86_64)
pacman -Syyu
pacman --needed -S base-devel git openssh bash-completion colordiff htop # x86_64: +multilib-devel
	### nur desktop installation mit Xserver
	pacman --needed -S sudo infinality-bundle xorg xorg-xinit i3 dmenu rxvt-unicode (lxappearence) irssi # x86_64: +infinality-bundle-multilib (mesa-libgl [default])
	# xorg:			1 3 5 27 40 64-67 [7 28 bei vmware-gast]
	# install archive tools
	# /etc/X11/xorg.conf.d/10-keyboard.conf anlegen
	# /etc/X11/xorg.conf.d/20-video.conf anlegen (bei vbox-only image)

LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > /pkglist.txt
#awk '{gsub("/"," "); gsub("-[0-9].*", " ", $2); print $2}' pkglist.txt
pacman -Scc
pacman-optimize
# Passwort für default Benutzer 'arch' festlegen (arch)
# benutzer anlegen
# dotfiles

### SYSLINUX Anpassungen
# /boot/syslinux
# $esp/EFI/syslinux ???
# APPEND gfdhgf=jsdh (global)
# keymap
exit
### ende chroot ###

mv mnt/pkglist.txt /mnt/archdata/archiso/customize/arch/pkglist.[arch].txt
umount mnt
rm -r airootfs.sfs mnt
mksquashfs squashfs-root airootfs.sfs
rm -r squashfs-root
md5sum airootfs.sfs > airootfs.md5
### DONE -> switch to i686

### find label for iso image
#lsblk -n -o MOUNTPOINT,LABEL -I 7 | grep "[mountpoint]" | cut -d ' ' -f 2
iso_label=$(lsblk -n -o MOUNTPOINT,LABEL -I 7 | grep "[mountpoint]" | awk '{print $2}')
#iso_label=$(file filename.iso | grep -oE "'[[:print:]]*'" | sed "s/'//g)

### https://projects.archlinux.org/archiso.git/tree/archiso/mkarchiso
# wenn datei fehlt: dd if=/path/to/archISO bs=512 count=1 of=~/customiso/isolinux/isohdpfx.bin
xorriso	-as mkisofs \
		-iso-level 3 \
		-full-iso9660-filenames \
		-volid "${iso_label}" \
		-eltorito-boot isolinux/isolinux.bin \
		-eltorito-catalog isolinux/boot.cat \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-isohybrid-mbr ~/customiso/isolinux/isohdpfx.bin \
		-eltorito-alt-boot \
		-e EFI/archiso/efiboot.img \
		-no-emul-boot -isohybrid-gpt-basdat \
		-output arch-custom.iso \
		~/customiso
