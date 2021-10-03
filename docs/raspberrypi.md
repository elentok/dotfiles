# Raspberry PI Setup

## Prepare SD card

1. Download the [Raspberry PI Imager][1].
2. Install "Raspberry PI OS".
3. Open the "boot" partition and create an empty "ssh" file (to enable the SSH
   server on startup).
4. Connect the SD Card to the Raspberry PI and power it on.

## Setup Raspberry PI

1. Run `ssh pi@raspberrypi` and enter `raspberry` as the password.
2. Run `sudo raspi-config`

   1. Select "1. System Options" => "S3 Password" to change the default password
      for the "pi" user.
   2. Select "1. System Options" => "S4 Hostname" to change the hostname.
   3. Select "5. Localisation Options" => "L2 Timezone" to set the timezone.

## Create personal user

```
NAME=...

# Create group by the same name as the user (the primary group)
sudo groupadd $NAME

# Create user with the same groups as "pi"
sudo useradd --create-home --gid $NAME --groups $(groups | tr ' ' ,) $NAME
sudo passwd $NAME
```

## Setup SSH key-based access

On the Raspberry PI:

```
mkdir ~/.ssh
vi  ~/.ssh/authorized_keys
# Paste the public key
```

[1]: https://www.raspberrypi.org/software/
