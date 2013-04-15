#!/bin/bash


source `dirname $0`/config.sh

if [ "$OS" == "mac" ]; then

  ./nodejs/install.sh $*
  ./git/install.sh $*
  ./zsh/install.sh $*
  ./tmux/install.sh $*
  ./vim/install.sh $*
  ./ack/install.sh $*
  ./ruby/install.sh $*
  #./modules/mac-smb-performance-fix/install.sh $*

else

  header "Base packages"
  sudo apt-get install -y vim-gnome mercurial \
    ctags keepassx gimp htop \
    samba libpam-smbpass \
    pysdm unrar regexxer \
    krusader vlc

  header "Modules"
  ./git/install.sh $*
  ./zsh/install.sh $*
  ./tmux/install.sh $*
  ./vim/install.sh $*
 $*
  ./modules/ack-grep/install.sh $*
  ./modules/mc/install.sh $*
  ./modules/mpd/install.sh $*
  ./modules/ruby/install.sh $*
  ./modules/nodejs.sh $*
  sudo ./modules/google.sh $*
  ./modules/movgrab.sh $*
  ./modules/jdownloader.sh $*
  ./modules/handbrake.sh $*
  ./modules/lamp.sh $*
fi
