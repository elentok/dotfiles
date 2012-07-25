#!/bin/bash
#
# ========================================
# Base packages
sudo apt-get install vim-gnome mercurial \
  ctags keepassx gimp htop \
  samba libpam-smbpass \
  pysdm unrar regexxer \
  krusader vlc

# screen \
#sudo apt-get install network-manager-gnome \
#  pcmanfm leafpad gpicview scrot

# set pcmanfm as the default file manager
#xdg-mime default pcmanfm.desktop inode/directory
# set leafpad as the default text editor
#xdg-mime default leafpad.desktop text/plain

# ========================================
# Modules
./modules/git/install.sh
./modules/ack-grep/install.sh
./modules/mc/install.sh
./modules/zsh/install.sh
./modules/mpd/install.sh
./modules/ruby/install.sh
./modules/tmux/install.sh
#./modules/iphone-tether.sh
./modules/nodejs.sh
sudo ./modules/google.sh
./modules/movgrab.sh
./modules/jdownloader.sh
./modules/handbrake.sh
./modules/lamp.sh
#./modules/java.sh

#./modules/i3/install.sh
#./modules/xfce4-terminal/install.sh
#./modules/urxvt/install.sh

#./modules/sublimetext.sh
