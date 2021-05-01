#!/usr/bin/zsh
# PHASE 3

# Swap File untested
cd /.swapvol
truncate -s 0 main
chattr +C main
btrfs property set main compression none
fallocate -l 16G main
chmod 600 main
mkswap main
swapon main

echo -e '\n#Swap\n /.swapvol/main swap swap defaults 0 0' >> /etc/fstab

echo ghostshell > /etc/hostname

hwclock --systohc --utc

echo LANG=en_US.UTF-8 > /etc/locale.conf

sed -i 's/#es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#es_ES ISO-8859-1/es_ES ISO-8859-1/g' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
locale-gen

echo "KEYMAP=es" > /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo -e "127.0.0.1\tlocalhost" > /etc/hosts
echo -e "::1\tlocalhost" >> /etc/hosts
echo -e "127.0.0.1\tghostshell.localdomain ghostshell" >> /etc/hosts

echo 'Password root'
passwd

echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)
useradd -m -G wheel user
echo 'Password USER'
passwd user

# PHASE 4
pacman -S --noconfirm --needed intel-ucode

# Initramfs
##Configure the creation of initramfs by editing /etc/mkinitcpio.conf. Change the line HOOKS=... to:
##HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
##HOOKS="base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems"
sed -i 's/^HOOKS=(.*)/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems)/g' /etc/mkinitcpio.conf

# Recreate initramfs:
mkinitcpio -p linux

# Boot Manager

bootctl --path=/boot install

UUID=$(blkid -s UUID -o value /dev/sda2) 

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$UUID:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" >> /boot/loader/entries/arch.conf

echo "default  arch.conf" >> /boot/loader/loader.conf
echo "timeout  4" >> /boot/loader/loader.conf
echo "console-mode max" >> /boot/loader/loader.conf
echo "editor   no" >> /boot/loader/loader.conf

systemctl enable NetworkManager.service
systemctl enable sshd.service
exit
