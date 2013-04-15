#!/bin/bash

source `dirname $0`/../config.sh

install_tmux() {
  if [ "$OS" == "mac" ]; then
    brew_install tmux
    brew_install reattach-to-user-namespace
    # for more info, see:
    #   http://robots.thoughtbot.com/post/19398560514/how-to-copy-and-paste-with-tmux-on-mac-os-x
  else
    sudo apt-get install -y tmux
  fi
}

install_symlinks() {
  symlink "$DOTF/tmux/tmux.conf" ~/.tmux.conf
}


header "tmux"
if [ "$1" != "symlinks" ]; then
  install_tmux
fi
install_symlinks
