#!/bin/bash

source `dirname $0`/../config.sh

main() {
  header "Vim"

  if [ "$OS" == "mac" ]; then
    install_on_mac
  else
    install_on_linux
  fi

  install_symlinks
  install_vim_plugins
  install_utils
}

install_on_mac() {
  brew_install macvim --with-cscope --override-system-vim --with-lua
  create_vim_bin_symlink

  brew_install ctags
  brew_install the_silver_searcher # ag
}

create_vim_bin_symlink() {
  latest_vim=`/bin/ls -1 -d $BREW_HOME/Cellar/macvim/7.* | sort -n | tail -1`
  symlink $latest_vim/bin/vim /usr/bin/vim
}

install_on_linux() {
  if [ "$HAS_GUI" == "yes" ]; then
    apt_install vim-gnome
    bullet "Installing Powerline fonts\n"
    bash "$DOTF/vim/powerline-fonts/install.sh"
  else
    apt_install vim
  fi

  apt_install exuberant-ctags tidy

  #add_ppa tomaz-muraus/the-silver-searcher
  #apt_install the-silver-searcher
  install_deb the-silver-searcher http://swiftsignal.com/packages/ubuntu/quantal/the-silver-searcher_0.14-1_amd64.deb
}

install_symlinks() {
  symlink "$DOTF/vim/vimrc" ~/.vimrc
  symlink "$DOTF/vim" ~/.vim
  symlink "$DOTF/vim/bundle/supertagger/ctags" ~/.ctags
  symlink "$DOTF/vim/pylintrc" ~/.pylintrc
}

install_vim_plugins() {
  bullet "Running PlugInstall... "
  vim +PlugInstall +qall
  success "done"
}

install_utils() {
  npm_install vimspec
  npm_install coffeelint
  npm_install jshint
  npm_install jsonlint
  npm_install marked
  pip_install pylint
  pip_install powerline-status
}

main $@
