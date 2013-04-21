#!/bin/bash

source `dirname $0`/../config.sh

install_zsh() {
  if [ "$OS" == "mac" ]; then
    brew_install zsh
    if [ "$SHELL" != "/bin/zsh" ]; then
      bullet "Changing shell to /bin/zsh... "
      chsh -s /bin/zsh
    fi
  else
    apt_install zsh
    if [ "$SHELL" != "/bin/zsh" ]; then
      bullet "Changing shell to /bin/zsh... "
      sudo usermod -s /bin/zsh $USER
    fi
  fi
}


install_prezto() {
  bullet "Installing prezto..."
  if [ ! -d ~/.zprezto ]; then
    git_clone https://github.com/sorin-ionescu/prezto.git ~/.zprezto --recursive 
  else
    info " already exists"
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
  install_prezto_symlinks

  symlink "$DOTF/zsh" ~/.zsh 
  symlink "$DOTF/zsh/zshrc" ~/.zshrc
  symlink "$DOTF/zsh/zpreztorc" ~/.zpreztorc
  symlink "$DOTF/zsh/prompt_elentok_setup" ~/.zprezto/modules/prompt/functions/prompt_elentok_setup
}

header "Zsh"

if [ "$1" == "symlinks" ]; then
  install_symlinks
else
  install_zsh
  install_prezto
  install_symlinks
fi
