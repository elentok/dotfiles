#!/bin/bash

source `dirname $0`/../config.sh

NEOROOT=$HOME/.neovim-src

install_requirements() {
  brew_install md5sha1sum libtool automake cmake
}

install_neovim() {
  if [ ! -e "$NEOROOT" ]; then
    mkdir -p $NEOROOT
  fi

  cd $NEOROOT
  git_clone https://github.com/neovim/neovim neovim
  git_clone https://github.com/neovim/docs docs
  git_clone https://github.com/neovim/vimscript vimscript

  cd neovim
  make clean
  #cmake -DCMAKE_INSTALL_PREFIX=$NEOROOT
  make cmake
  make
}

install_symlinks() {
  symlink "$DOTF/nvim/nvimrc" ~/.nvimrc
}

install_requirements
install_neovim
install_symlinks
