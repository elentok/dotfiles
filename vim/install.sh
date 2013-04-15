#!/bin/bash

source `dirname $0`/../config.sh

install_on_mac() {
  header "Installing MacVim"
  brew install macvim --with-cscope --override-system-vim --with-lua
  cd /usr/bin
  sudo mv vim vim-builtin
  latest_vim=`/bin/ls -1 -d /usr/local/Cellar/macvim/7.* | tail -1`
  sudo ln -s $latest_vim/bin/vim vim

  header "Installing ctags"
  brew install ctags
}

install_on_linux() {
  header "Installing Powerline fonts"
  if [ "`uname -s`" == "Linux" ]; then
    bash "$DOTF/vim/powerline-fonts/install.sh"
  fi
}

install_symlinks() {
  header "Installing ~/.vim and ~/.vimrc symlinks"
  symlink "$DOTF/vim/vimrc" ~/.vimrc
  symlink "$DOTF/vim" ~/.vim
  symlink "$DOTF/vim/pylintrc" ~/.pylintrc
}

install_vundle() {
  header "Installing Vundle"
  cd ~/.vim
  git clone http://github.com/gmarik/vundle.git bundle/vundle
  vim +BundleInstall +qall
}

install_utils() {
  header "Installing Utils (Linters, Silver Searcher, ...)"

  npm_install coffeelint
  npm_install jshint
  npm_install jsonlint
  npm_install marked
  python_install pylint
  brew install tidy
  brew install ag # the silver searcher
}

if [ "$1" == "symlinks" ]; then
  install_symlinks
else
  if [ "`uname -s`" == "Darwin" ]; then
    install_on_mac
  else
    install_on_linux
  fi

  install_symlinks
  install_vundle
  install_utils
fi
