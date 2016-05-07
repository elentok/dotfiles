Arch Linux
==========

Based on the amazing [Arch Linux Wiki](https://wiki.archlinux.org/index.php/Beginners%27_guide)

Installation
------------

### Create Partitions

```
lsblk                  # identify devices
cfdisk /dev/sdX        # create partitions and format

mkfs.ext4 /dev/sdXA    # format ext4 partition
mkswap /dev/sdXB
swapon /dev/sdXB

sysctl vm.swappiness=1 # when using SSD, minimize swappiness

mount /dev/sdXA /mnt
```

### Install

```
pacstrap -i /mnt base base-devel   # install base packages
genfstab -U /mnt >> /mnt/etc/fstab # if using SSD, add "noatime" to fstab
                                   # (to avoid write last access times)
arch-chroot /mnt /bin/bash
```

### Locales

Edit `/etc/locale.gen`, uncomment `en_US.UTF-8 UTF-8` and run:

```
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

### Time

```
tzselect
ln -s /usr/share/zoneinfo/{Zone}/{SubZone} /etc/localtime
hwclock --systohc --utc

```

### Grub

```
pacman -S grub os-prober
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

### Hostname

```
echo '{HOSTNAME}' > /etc/hostname
```

Edit `/etc/hosts` and add the hostname to the end of the `localhost` entries

### Enable DHCP

```
ls /sys/class/net # get device names
systemctl enable dhcpcd@{device-name}.service

```

### Set the ROOT password

```
passwd
```

### Unmount & Reboot

```
exit            # leave the chroot environment
umount -R /mnt
reboot
```

### Install basic packages

```
pacman -S zsh neovim git tig the_silver_searcher
```

Create user
-----------

```
useradd -m -G wheel -s /usr/bin/zsh {USER}
usermod -aG users {USER}
passwd {USER}
```

Run `visudo` and uncomment the line `%wheel ALL=(ALL) ALL` to allow all members
of the `wheel` group to run `sudo`

Install GUI
-----------

```
pacman -S cinnamon lightdm gnome-terminal
```
