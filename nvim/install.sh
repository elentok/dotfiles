#!/bin/bash

source `dirname $0`/../config.sh

install_neovim() {
  if [ ! -e "$HOME/.neovim-src" ]; then
    cd
    git clone https://github.com/neovim/neovim .neovim-src
    cd .neovim-src
    make cmake
    make
  fi
}

install_symlinks() {
  symlink "$DOTF/nvim/neovimrc" ~/.neovimrc
}

install_neovim
install_symlinks
