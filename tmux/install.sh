#!/bin/bash

source `dirname $0`/../config.sh

install_tmux() {
  header "Installing tmux"
  if [ "$OS" == "mac" ]; then
    brew install tmux

    brew install reattach-to-user-namespace
    # for more info, see:
    #   http://robots.thoughtbot.com/post/19398560514/how-to-copy-and-paste-with-tmux-on-mac-os-x
  else
    sudo apt-get install -y tmux
  fi
}

install_symlinks() {
  header "Installing ~/.tmux.conf symlink"
  symlink "$DOTF/tmux/tmux.conf" ~/.tmux.conf
}

if [ "$1" == "symlinks" ]; then
  install_symlinks
else
  install_tmux
  install_symlinks
fi
