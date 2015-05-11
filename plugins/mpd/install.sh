#!/bin/bash

source `dirname $0`/../../config.sh

install_on_mac() {
  brew_install mpd
  brew_install mpc
  brew_install ncmpcpp
}

install_on_linux() {
  bullet "Installing mpd + clients"
  sudo apt-get install -y mpd mpc ncmpcpp ncmpc-lyrics

  bullet "Remove mpd from update-rc.d"
  sudo update-rc.d -f mpd remove
}

create_symlinks() {
  bullet "Creating symlinks... "
  mkdir -p ~/.mpd
  mkdir -p ~/.mpd/playlists/
  mkdir -p ~/.mpd/var/
  touch ~/.mpd/var/tag_cache
  ln -sf "$DOTF/plugins/mpd/mpd.conf" ~/.mpd/mpd.conf

  mkdir -p ~/.ncmpcpp
  ln -sf "$DOTF/plugins/mpd/ncmpcpp-config" ~/.ncmpcpp/config
  ln -sf "$DOTF/plugins/mpd/ncmpcpp-bindings" ~/.ncmpcpp/bindings

  success "done"
}

header "Music Player Daemon"

if [ "$OS" == "mac" ]; then
  install_on_mac
else
  install_on_linux
fi

create_symlinks

