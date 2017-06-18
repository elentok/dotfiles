Ubuntu Tweaks
==============

## nVidia HDMI Audio

source: https://wiki.archlinux.org/index.php/PulseAudio/Examples#HDMI_output_configuration

1) list all of the available audio outputs:

    aplay -l

2) test for the correct card:

    aplay -D plughw:1,8 /usr/share/sounds/alsa/Front_Right.wav

  where 1 is the card and 3 is the device substitute in the values listed from
  the previous section. If there is no audio, then try substituting a different
  device (on my card I had to use card 1 device 8)

3) edit `/etc/pulse/default.pa`:

    load-module module-alsa-sink device=hw:1,8

  where the 1 is the card and the 8 is the device found to work in the previous
  section.

4) restart pulse audio

    $ pulseaudio -k
    $ pulseaudio --start

Touchpad
---------

to reenable the touchpad after it has stopped run:
  synclient TouchpadOff=0

Create special user for file sharing
-------------------------------------

1. create the system user: 

```bash
  $ sudo useradd <username> -p <password> -g users
```

2. create the samba user:

```bash
  $ sudo smbpasswd -a <username>
```

3. add the user to the /etc/samba/smbusers file:

```bash  
  $ sudo su
  $ echo '<username> = "<username>"' > /etc/samba/smbusers
```

NOTE: when mounting partitions use the "users" group as the mountpoint's group.

Auto-mount partitions
-----------------------

## Option #1: Edit fstab manually

```
{device} {mount-path} ntfs nls=iso8859-8,umask=027,utf8,gid=sambashare,uid=david 0 0
```

For example:
```
/dev/sdb1 /media/hd1 ntfs nls=iso8859-8,umask=027,utf8,gid=sambashare,uid=david 0 0
```

## Option #2: Using pysdm

1. Install the "Storage Device Manager":

```bash
  $ sudo apt-get install pysdm
```

2. Open it, and for each partition use these settings:

```bash
  nls=iso8859-8,umask=027,utf8,gid=sambashare,uid=david
```

  by setting the gid to "users", the special samba user defined in the previous section
  can access shares on these partitions. Also, by setting the "umask" to 027 that user
  will only have read-access.

## Java


download jre from http://www.java.com and extract it to /usr/lib/jvm

```bash
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.7.0_05/bin/java 2
sudo update-alternatives --config java
```

## Change default terminal (x-terminal-emulator)

sudo update-alternatives --config x-terminal-emulator
