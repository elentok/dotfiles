Ubuntu Tweaks
==============

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

1. Install the "Storage Device Manager":

```bash
  $ sudo apt-get install pysdm
```

2. Open it, and for each partition use these settings:

```bash
  nls=iso8859-8,umask=027,utf8,gid=users,uid=david
```

  by setting the gid to "users", the special samba user defined in the previous section
  can access shares on these partitions. Also, by setting the "umask" to 027 that user
  will only have read-access.

Java
-----

download jre from http://www.java.com and extract it to /usr/lib/jvm

```bash
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.7.0_05/bin/java 2
sudo update-alternatives --config java
```
