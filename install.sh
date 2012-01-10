#!/bin/bash

# ========================================
# Base packages
apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm unrar regexxer zsh screen \
  xfce4-terminal network-manager-gnome \
  krusader vlc

# ========================================
# midnight commander
apt-get install mc
(
  cd mc/
  ./create-symlinks.sh
)

# ========================================
# oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
usermod -s /bin/zsh david

# ========================================
# i3
echo 'deb http://debian.sur5r.net/i3/ oneiric universe' >> /etc/apt/sources.list
apt-get update
apt-get --allow-unauthenticated install sur5r-keyring
apt-get update
apt-get install i3 feh

(
  cd i3/
  ./create-symlinks
)


# ========================================
# Music Player Daemon
apt-get install mpd mpc ncmpcpp ncmpc-lyrics
(
  cd mpd
  ./create-symlinks
)

# ========================================
# Git
apt-get install git 
git config --global --add color.ui true

# ========================================
# Ruby
./install-ruby.sh

# ========================================
# LAMP
apt-get install tasksel
tasksel install lamp-server
apt-get install php5-sqlite
service apache2 restart

# ========================================
# JDownloader
apt-add-repository ppa:jd-team/jdownloader
apt-get update
apt-get install jdownloader

# ========================================
# Chrome + Google talk plugin

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sh -c 'echo "deb http://dl.google.com/linux/talkplugin/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get update
apt-get install google-talkplugin google-chrome-stable
apt-get -f install

# ========================================
# Handbrake (Video converter)

add-apt-repository ppa:stebbins/handbrake-snapshots 
apt-get update
apt-get install handbrake

# ========================================
# Java
add-apt-repository ppa:ferramroberto/java
apt-get update
apt-get install sun-java6-jdk sun-java6-plugin

# ========================================
# Sublime Text (disabled)
#sudo add-apt-repository ppa:webupd8team/sublime-text-2
#sudo apt-get update
#sudo apt-get install sublime-text-2
## Coffeescript for Sublime Text
#wget https://github.com/HenriMorlaye/Coffeescript-package-for-Sublime-Text/zipball/master
#mv master coffeescript.zip
#mkdir -p ~/.config/sublime-text-2/Packages/CoffeeScript
#unzip -j coffeescript.zip -d ~/.config/sublime-text-2/Packages/CoffeeScript

