#!/bin/bash

source `dirname $0`/../config.sh

latest_version() {
  /bin/ls -1 $BREW_HOME/Cellar/go | grep -E '^[0-9\.]+$' | sort | tail -1
}

fix_go_locations() {
  latest=$(latest_version)
  symlink $BREW_HOME/Cellar/go/{$latest,default}
}

check_mac_installation() {
  if [ ! -x "$BREW_HOME/bin/go" ]; then
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

go_get() {
  pkg="$1"
  bullet "Installing Go package '$pkg'..."
  if [ -e "$GOPATH/src/$pkg" ]; then
    info " already installed"
  else
    info ""
    go get -u "$pkg"
  fi
}

if [ "$OS" == "mac" ]; then
  install_on_mac
fi

#install_goreplace
go_get github.com/nsf/gocode
go_get github.com/gpmgo/gopm
go_get github.com/codegangsta/gin
