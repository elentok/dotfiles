#!/bin/bash

source `dirname $0`/../config.sh

install_zsh() {
  if [ "$OS" == "mac" ]; then
    brew_install zsh
    my_shell=$(echo $SHELL | rev | cut -d/ -f1 | rev)
    if [ "$my_shell" != "zsh" ]; then
      zsh_bin="$(which zsh)"
      bullet "Changing shell to ${zsh_bin}... "
      chsh -s "$zsh_bin"
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
    [ "$name" == "zprofile" ] && continue
    [ "$name" == "zshenv" ] && continue
    [ "$name" == "zpreztorc" ] && continue
    symlink $rcfile ~/.$name
  done
}

install_symlinks() {
  install_prezto_symlinks

  symlink "$DOTF/zsh" ~/.zsh 
  symlink "$DOTF/zsh/zshrc" ~/.zshrc
  symlink "$DOTF/zsh/zprofile" ~/.zprofile
  symlink "$DOTF/zsh/zshenv" ~/.zshenv
  symlink "$DOTF/zsh/zpreztorc" ~/.zpreztorc
  symlink "$DOTF/zsh/prompt_elentok_setup" ~/.zprezto/modules/prompt/functions/prompt_elentok_setup
}

install_requirements() {
  brew_install coreutils
  brew_install fasd
  brew_install gnu-sed
}

header "Zsh"

if [ "$1" == "symlinks" ]; then
  install_symlinks
elif [ "$1" == "basic" ]; then
  install_prezto
  install_symlinks
else
  install_requirements
  install_zsh
  install_prezto
  install_symlinks
fi
