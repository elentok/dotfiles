#!/bin/bash

source `dirname $0`/../config.sh

install_on_mac() {
  brew_install hg
  brew_install go
  make_dir $HOME/.go
}

if [ "$OS" == "mac" ]; then
  install_on_mac
fi
