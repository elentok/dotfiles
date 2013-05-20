#!/bin/bash

source `dirname $0`/../config.sh

install_fish() {
  if [ "$OS" == "mac" ]; then
    install_fish_on_mac
  else
    apt_install fish
    if [ "$SHELL" != "/usr/local/bin/fish" ]; then
      bullet "Changing shell to /usr/local/bin/fish "
      sudo usermod -s /usr/local/bin/fish $USER
    fi
  fi
}

install_fish_on_mac() {
  brew_install_url fish https://raw.github.com/ridiculousfish/homebrew/9a481458491b654457707a75d98ad770ad248d88/Library/Formula/fish.rb
  add_to_etc_shells
}

add_to_etc_shells() {
  bullet "Adding to /etc/shells... "
  fish='/usr/local/bin/fish'

  if [ "$(grep $fish /etc/shells)" == "" ]; then
    sudo sh -c "echo $fish >> /etc/shells"
    mac_change_shell
  else
    info "already there"
  fi
}

mac_change_shell() {
  bullet "Changing shell to /usr/local/bin/fish... "
  chsh -s /usr/local/bin/fish
}

install_oh_my_fish() {
  bullet "Installing oh-my-fish... "
  if [ -e ~/.oh-my-fish ]; then
    info "already installed"
  else
    curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh
  fi
}

create_symlinks() {
  #mkdir -p ~/.config/fish/custom/plugins
  #symlink "$DOTF/fish" ~/.config/fish/custom/plugins/elentok
  symlink "$DOTF/fish/config.fish" ~/.config/fish/config.fish
}

install_fish
install_oh_my_fish
create_symlinks

