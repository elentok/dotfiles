#!/bin/bash
#
# ========================================
# Base packages
sudo apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm unrar regexxer screen \
  network-manager-gnome \
  krusader vlc scrot gpicview

# ========================================
# Modules
./modules/git/install.sh
./modules/ack-grep/install.sh
./modules/mc/install.sh
./modules/i3/install.sh
./modules/zsh/install.sh
./modules/mpd/install.sh
#./modules/xfce4-terminal/install.sh
./modules/urxvt/install.sh
./modules/ruby/install.sh
./modules/iphone-tether.sh
./modules/nodejs.sh
sudo ./modules/google.sh
./modules/movgrab.sh
./modules/jdownloader.sh
./modules/handbrake.sh
./modules/lamp.sh
./modules/java.sh

#./modules/sublimetext.sh
