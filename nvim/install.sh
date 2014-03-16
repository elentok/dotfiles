#!/bin/bash

source `dirname $0`/../config.sh

install_requirements() {
  brew_install md5sha1sum libtool automake cmake
}

install_neovim() {
  if [ ! -e "$HOME/.neovim-src" ]; then
    cd
    mkdir .neovim-src
    git_clone https://github.com/neovim/neovim neovim
    git_clone https://github.com/neovim/docs docs
    git_clone https://github.com/neovim/vimscript vimscript
    cd neovim
    make cmake
    make
  fi
}

install_symlinks() {
  symlink "$DOTF/nvim/nvimrc" ~/.nvimrc
}

install_requirements
install_neovim
install_symlinks
