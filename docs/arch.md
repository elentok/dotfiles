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

### Setup Network

First, get the name of the relevant network interface by running either of:

```
ip link
ls /sys/class/net
```

On a wired network, just enable the DHCP service:

```
systemctl enable dhcpcd@{device-name}.service

```

On a wireless network, connected to the access point and afterwards start the
dhcp client manually (if you enable the service like in wired network it will
delay the boot since it will try to enable DHCP without a WiFi connection):

```
wpa_supplicant -i INTERFACE -c <(wpa_passphrase "SSID" "PASSWORD")
dhcpcd INTERFACE

```

Running the DHCP client manually is only for the installation process,
afterwards you can use NetworkManager to do an easier setup.

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
ln -s /usr/share/zoneinfo/{Zone}/{SubZone} /etc/localtime
hwclock --systohc

```

### Grub

```
pacman -S grub os-prober intel-ucode
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

### Hostname

```
echo '{HOSTNAME}' > /etc/hostname
```

Edit `/etc/hosts` and add the hostname to the end of the `localhost` entries

```
127.0.0.1 localhost
::1       localhost
127.0.1.1 {HOSTNAME}.localdomain {HOSTNAME}
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
pacman -S zsh neovim git tig ripgrep
```

Install the packages required for making WiFi connections (post-boot):

```
pacman -S iw wpa_supplicant NetworkManager
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
pacman -S cinnamon lightdm lightdm-gtk-greeter gnome-terminal xorg-server \
  xorg-server-utils xclip

pacman -S xf86-video-intel mesa-libgl # if you have an intel graphics card:

systemctl enable lightdm.service # enable lightdm
```

Install Google Chrome
---------------------

* Install [Yaourt](https://archlinux.fr/yaourt-en)
* Run `yaourt -S google-chrome`

i3
---

Install the network manager (service + applet):

```
yaourt -S networkmanager network-manager-applet
systemctl enable NetworkManager
systemctl start NetworkManager
```

Audio
-----

```
sudo pacman -S pulseaudio pavucontrol
```


MacBook Air
-----------

### Use better trackpad driver

Install the mtrack driver:
```
yaourt -S xf86-input-mtrack.git
```

Put the following text in `/etc/X11/xorg.conf.d/10-mtrack.conf`:

```
Section "InputClass"
  MatchIsTouchpad "on"
  Identifier "Touchpads"
  Driver "mtrack"

  Option "Thumbsize" "50"
  Option "ScrollDistance" "100"

  # Natural two-finger scrolling (similar to OS X)
  Option "ScrollUpButton" "5"
  Option "ScrollDownButton" "4"
  Option "ScrollLeftButton" "7"
  Option "ScrollRightButton" "6"
EndSection
```
