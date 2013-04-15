#!/bin/bash

source `dirname $0`/../config.sh

install_on_mac() {
  brew_install macvim --with-cscope --override-system-vim --with-lua
  #create_vim_bin_symlink
}

create_vim_bin_symlink() {
  cd /usr/bin
  #sudo mv vim vim-builtin
  latest_vim=`/bin/ls -1 /usr/local/Cellar/macvim/7.* | sort -n | tail -1`
  #sudo ln -s $latest_vim/bin/vim vim
}

install_on_linux() {
  bullet "Installing Powerline fonts\n"
  if [ "`uname -s`" == "Linux" ]; then
    bash "$DOTF/vim/powerline-fonts/install.sh"
  fi
}

install_symlinks() {
  symlink "$DOTF/vim/vimrc" ~/.vimrc
  symlink "$DOTF/vim" ~/.vim
  symlink "$DOTF/vim/pylintrc" ~/.pylintrc
}

install_vundle() {
  cd ~/.vim
  git_clone http://github.com/gmarik/vundle.git bundle/vundle
  bullet "Running BundleInstall... "
  vim +BundleInstall +qall
  success "done"
}

install_utils() {
  brew_install ctags
  brew_install the_silver_searcher # ag
  npm_install coffeelint
  npm_install jshint
  npm_install jsonlint
  npm_install marked
  python_install pylint
  brew_install tidy
}

header "Vim"
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
