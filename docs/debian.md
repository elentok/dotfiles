## Allow user to run sudo

Add the user to the 'sudo' group: `usermod -aG sudo {USER}`

## Upgrade from 9.x (Stretch) to 10 (Buster)

```
sudo apt update
sudo apt upgrade
sudo apt full-upgrade
```

Edit `/etc/apt/sources.list` and change 'stretch' to 'buster'

```
sudo apt update
sudo apt upgrade
sudo apt full-upgrade
```
