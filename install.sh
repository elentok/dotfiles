#!/bin/bash


source `dirname $0`/config.sh

./nodejs/install.sh $*
./git/install.sh $*
./zsh/install.sh $*
./tmux/install.sh $*
./vim/install.sh $*
./ack/install.sh $*
./ruby/install.sh $*
./todo/install.sh $*

if [ "$OS" == "mac" ]; then
  echo .
  #./modules/mac-smb-performance-fix/install.sh $*
else

  header "Base packages"
  sudo apt-get install -y mercurial \
    keepassx gimp htop \
    samba libpam-smbpass \
    pysdm unrar regexxer \
    krusader vlc

  #header "Modules"
  #./modules/mc/install.sh $*
  #./modules/mpd/install.sh $*
  #sudo ./modules/google.sh $*
  #./modules/movgrab.sh $*
  #./modules/jdownloader.sh $*
  #./modules/handbrake.sh $*
  #./modules/lamp.sh $*
fi
