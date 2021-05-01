#!/usr/bin/zsh

#Temporary change of keyboard language
loadkeys es

#Oneliner partitioning:
parted --script /dev/sda mklabel gpt mkpart EFI fat32 1MiB 550MiB set 1 esp on mkpart crypt ext4 550MiB 100%

# Encryption, solicita YES y la clave de cifrado.
cryptsetup luksFormat /dev/sda2 || exit

# PHASE 2
cryptsetup open /dev/sda2 luks || exit

# File System Creation
mkfs.vfat -F32 -n EFI /dev/sda1
mkfs.btrfs -L ROOT /dev/mapper/luks

# Create and Mount Subvolumes
mount /dev/mapper/luks /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots

#SWAPFILE NOT TESTED https://blog.passcod.name/2020/jun/16/full-disk-encryption-with-btrfs-swap-and-hibernation.html
btrfs sub create /mnt/@swap
btrfs sub create /mnt/@btrfs
umount /mnt


mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,.swapvol,btrfs}
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots

#Swap FILE untested
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@swap /dev/mapper/luks /mnt/.swapvol
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvolid=@btrfs /dev/mapper/luks /mnt/btrfs

# Mount the EFI partition
mount /dev/sda1 /mnt/boot

# Base System and /etc/fstab
pacstrap /mnt base base-devel linux linux-firmware nano btrfs-progs efibootmgr grub networkmanager openssh git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

#Doenload phase 2 in /mnt/root

# System Configuration
cp ./ArchPhase2.sh /mnt/ArchPhase2.sh
arch-chroot /mnt/ bash ./ArchPhase2.sh || exit

# Copy script and execute
# chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

## Ins script -> download and exec installi3, download and exesute install config

umount -Rf /mnt
echo reboot
