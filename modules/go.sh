#!/bin/bash

source `dirname $0`/../config.sh

latest_version() {
  /bin/ls -1 /usr/local/Cellar/go | grep -E '^[0-9\.]+$' | sort | tail -1
}

fix_go_locations() {
  latest=$(latest_version)
  symlink /usr/local/Cellar/go/{$latest,default}
}

check_mac_installation() {
  if [ ! -x "/usr/local/bin/go" ]; then
    brew remove --force go
  fi
}

install_on_mac() {
  check_mac_installation
  brew_install mercurial
  brew_install go
  make_dir $HOME/.go-global
  fix_go_locations
}

install_goreplace() {
  cd ~/.go-global
  mkdir -p bin
  cd bin
  go get github.com/piranha/goreplace
  go build github.com/piranha/goreplace
}

install_gocode() {
  go get -u github.com/nsf/gocode
}

if [ "$OS" == "mac" ]; then
  install_on_mac
fi

install_goreplace
install_gocode
