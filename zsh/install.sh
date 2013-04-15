#!/bin/bash

source `dirname $0`/../config.sh

install_zsh() {
  header "Installing Zsh"
  if [ "`uname -s`" = "Darwin" ]; then
    brew install zsh
    if [ "$SHELL" != "/bin/zsh" ]; then
      chsh -s /bin/zsh
    fi
  else
    sudo apt-get install -y zsh
    sudo usermod -s /bin/zsh $USER
  fi
}


install_prezto() {
  header "Installing Prezto"
  if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
  else
    info "skipping, already exists"
  fi

}

install_prezto_symlinks() {
  for rcfile in ~/.zprezto/runcoms/z*; do
    name=`basename $rcfile`
    [ "$name" == "zshrc" ] && continue
    [ "$name" == "zpreztorc" ] && continue
    symlink $rcfile ~/.$name
  done
}

install_symlinks() {
  header "Installing symlinks"
  install_prezto_symlinks

  symlink "$DOTF/zsh" ~/.zsh 
  symlink "$DOTF/zsh/zshrc" ~/.zshrc
  symlink "$DOTF/zsh/zpreztorc" ~/.zpreztorc
  symlink "$DOTF/zsh/prompt_elentok_setup" ~/.zprezto/modules/prompt/functions/prompt_elentok_setup
}

if [ "$1" == "symlinks" ]; then
  install_symlinks
else
  install_zsh
  install_prezto
  install_symlinks
fi
