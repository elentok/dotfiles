#!/bin/bash

source `dirname $0`/../config.sh

install_on_mac() {
  brew_install hg
  brew_install go
  make_dir $HOME/.go

  mv /usr/local/Cellar/go/1.0.3/bin/* /usr/local/Cellar/go/1.1/bin/
}

install_goreplace() {
  cd ~/.go
  mkdir -p bin
  cd bin
  go get github.com/piranha/goreplace
  go build github.com/piranha/goreplace
}

if [ "$OS" == "mac" ]; then
  install_on_mac
fi

install_goreplace
