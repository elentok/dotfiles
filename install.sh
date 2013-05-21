#!/bin/bash


source `dirname $0`/config.sh

if [ "`which say`" != "" ]; then
  say -v Zarvox 'Update sequence initialized' &
fi

./nodejs/install.sh $*
./git/install.sh $*
./fish/install.sh $*
./tmux/install.sh $*
./vim/install.sh $*
./ack/install.sh $*
./ruby/install.sh $*
./todo/install.sh $*

if [ "$OS" == "mac" ]; then
  ./keyremap4macbook/install.sh

  header 'Other packages'
  brew_install imagemagick
  #./modules/mac-smb-performance-fix/install.sh $*
else

  header "Base packages"

  apt_install mercurial htop samba libpam-smbpass unrar

  if [ "`which X`" != "" ]; then
    ./modules/linux-gui-apps.sh
  fi

  #header "Modules"
  #./modules/mc/install.sh $*
  #./modules/mpd/install.sh $*
  #sudo ./modules/google.sh $*
  #./modules/movgrab.sh $*
  #./modules/jdownloader.sh $*
  #./modules/handbrake.sh $*
  #./modules/lamp.sh $*
fi

if [ "`which say`" != "" ]; then
  say -v Zarvox 'Update sequence complete'
fi
