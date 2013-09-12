#!/bin/bash

source `dirname $0`/../config.sh

RUBY_VERSION='2.0.0-p247'

install_rbenv() {
  brew_install rbenv
  brew_install ruby-build
  eval "$(rbenv init -)"
}

install_requirements() {
  if [ "$OS" == "linux" ]; then
    bullet "Installing rvm requirements"
    # run "rvm requirements" and you get this list of packages:
    apt_install build-essential openssl libreadline6 libreadline6-dev \
      curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 \
      libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev \
      automake libtool bison subversion

    #sudo apt-get install -y libreadline-gplv2-dev libreadline-dev
    apt_install libreadline-dev
    apt_install libxslt1-dev
  fi
}

install_ruby() {
  bullet "Installing ruby $RUBY_VERSION... "
  if [ "`rbenv versions | grep $RUBY_VERSION`" == "" ]; then
    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
  else
    info "already installed"
  fi
}

create_symlinks() {
  symlink "$DOTF/ruby/irbrc" ~/.irbrc
  symlink "$DOTF/ruby/rdebugrc" ~/.rdebugrc
  symlink "$DOTF/ruby/editrc" ~/.editrc
}

install_phantomjs() {
  if [ "$OS" == "mac" ]; then
    brew_install phantomjs
  else
    install_phantomjs_on_linux
  fi
}

install_phantomjs_on_linux() {
  bullet "Installing phantomjs... "
  if [ "`which phantomjs`" != "" ]; then
    info "already installed"
  else
    cd ~/Downloads
    wget http://phantomjs.googlecode.com/files/phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2
    tar xjvf phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2
    sudo mv phantomjs-1.6.0-linux-x86_64-dynamic /opt/phantomjs
    sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/
  fi
}

header "Ruby"
if [ "$1" != "symlinks" ]; then
  #install_requirements
  install_rbenv
  install_ruby
  #install_ruby
  #install_phantomjs
fi
create_symlinks
