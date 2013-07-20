#!/bin/bash

source `dirname $0`/../config.sh

latest_version() {
  /bin/ls -1 /usr/local/Cellar/go | grep -E '^[0-9\.]+$' | sort | tail -1
}

install_on_mac() {
  brew_install mercurial
  brew_install go
  make_dir $HOME/.go
  fix_go_locations
}

fix_go_locations() {
  latest=$(latest_version)
  symlink /usr/local/Cellar/go/{$latest,default}
  symlink /usr/local/Cellar/go/1.0.3/bin /usr/local/Cellar/go/bin
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
