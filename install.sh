#!/bin/bash

# ========================================
# Base packages
apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm unrar regexxer screen \
  xfce4-terminal network-manager-gnome \
  krusader vlc

# ========================================
# Modules
./modules/mc/install.sh
./modules/i3/install.sh
./modules/zsh/install.sh
./modules/ruby.sh
./modules/lamp.sh
./modules/jdownloader.sh
./modules/google.sh
./modules/java.sh
./modules/handbrake.sh
#./modules/sublimetext.sh

# ========================================
# Git
apt-get install git 
git config --global --add color.ui true

