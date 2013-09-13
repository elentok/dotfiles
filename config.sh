#!/bin/bash
# vim: foldmethod=marker

# DOTF directory {{{1

DOTF=`dirname ${BASH_SOURCE[0]-$0}`
export DOTF=`cd $DOTF && pwd`


# Colors {{{1
export BLACK="\033[30m"
export GRAY="\033[1;30m"
export RED="\033[31m"
export GREEN="\033[32m"
export YELLOW="\033[33m"
export BLUE="\033[34m"
export CYAN="\033[36m"
export UNDERLINE="\033[4m"
export RESET="\033[0m"

# Identify OS {{{1
if [ "`uname -s`" = "Darwin" ]; then
  export OS=mac
else
  export OS=linux
fi

if [ "`which X`" = "" ]; then
  export HAS_GUI=no
else
  export HAS_GUI=yes
fi

# display methods (header/bullet/info/success/error) {{{1
header() {
  echo -e "\n${BLUE}${UNDERLINE}☻ $*$RESET"
}

bullet() {
  echo -e -n "${YELLOW}➜$RESET $*"
}

info() {
  echo -e "${GRAY}$*$RESET"
}

success() {
  echo -e "${GREEN}✔ $*$RESET"
}

error() {
  echo -e "${RED}✘ $*$RESET"
}

# confirm {{{1
confirm() {
  read "yesno?${1} (yes/[no])? "
  [ "$yesno" = "yes" ]
  return $?
}
# backup {{{1
backup() {
  info "\n  backing up to ${1}.backup"
  mv -f "$1" "${1}.backup"
  if [ $? == 0 ]; then return; fi

  info "  trying with sudo:"
  sudo mv -f "$1" "${1}.backup"
  if [ $? != 0 ]; then
    error "FAILED"
    exit 1
  fi
}

# symlink {{{1
symlink() {
  source=$1
  target=$2

  bullet "Linking $source\n      ==> ${target}... "
  if [ -e "$target" ]; then
    if [ -h "$target" ]; then
      if [ "$source" == "$(readlink "$target")" ]; then
        info " already exists"
        return
      fi
    fi

    backup "$target"
  fi

  ln -sf "$source" "$target"
  if [ $? != 0 ]; then
    info "  Can't create link, trying with sudo:"
    sudo ln -sf "$source" "$target"
    if [ $? != 0 ]; then
      error "failed"
      exit 1
    fi
  fi
  if [ $? == 0 ]; then
    success "done"
  fi
}

# NPM {{{1
npm_install() {
  bullet "Installing ${1}..."

  if [ "`npm_cache | grep \"\\b$1\\b\"`" ]; then
    info " already installed"
  else
    npm="npm"
    if [ "$OS" == "linux" ]; then npm="sudo npm"; fi
    $npm install -g $*
  fi
}

rm -f /tmp/npm_cache

npm_cache() {
  if [ ! -e /tmp/npm_cache ]; then
    npm ls -g 2>/dev/null > /tmp/npm_cache
  fi
  cat /tmp/npm_cache
}

# Gems {{{1

gem_install() {
  for gem in $*; do
    gem_install_single $gem
  done
}

gem_install_single() {
  bullet "Installing gem ${1}... "
  if [ "`gem_cache | grep \"^$1\\b\"`" != "" ]; then
    info "already installed"
  else
    gem install $*
    rm -f /tmp/gem_cache
  fi
}

rm -f /tmp/gem_cache

gem_cache() {
  if [ ! -e /tmp/gem_cache ]; then
    gem list > /tmp/gem_cache
  fi
  cat /tmp/gem_cache
}

# Homebrew {{{1
brew_install() {
  bullet "Installing ${1}... "

  #if [ "`brew ls -1 | grep \"^$1\$\"`" != "" ]; then
  if has_brew_package "$1"; then
    info "already installed"
  else
    brew install $*
  fi
}

brew_install_url() {
  name=$1
  shift

  bullet "Installing ${name}... "
  if has_brew_package "$name"; then
    info "already installed"
  else
    brew install $*
  fi
}

has_brew_package() {
  [ "`brew ls -1 | grep \"^$1\$\"`" != "" ]
}

brew_tap() {
  repo=$1
  bullet "Tapping brew repository ${repo}... "
  if has_brew_tap "$repo"; then
    info "already installed"
  else
    brew tap $*
  fi
}

has_brew_tap() {
  [ "`brew tap | grep \"^$1\$\"`" != "" ]
}

# Homebrew Cask {{{1

brew_cask_install() {
  bullet "Installing ${1}... "

  if has_brew_cask_package "$1"; then
    info "already installed"
  else
    brew install $*
  fi
}

has_brew_cask_package() {
  [ "`brew cask list | grep \"^$1\$\"`" != "" ]
}

# Python {{{1
python_install() {
  bullet "Installing ${1}... "
  if [ "`which $1`" != "" ]; then
    info " already installed"
  else
    sudo easy_install $1
  fi
}

# Git {{{1
git_clone() {
  origin=$1
  target=$2
  bullet "Cloning $origin => ${target}..."
  if [ -d $target ]; then
    if [ -d $target/.git ]; then
      current_origin=`cd $target && git_get_origin`
      if [ "$current_origin" == "$origin" ]; then
        info " already cloned"
        # thought: (cd $target && git pull)
        return
      fi
    fi
    backup $target
  fi

  git clone $*
}

git_get_origin() {
  git remote -v | grep fetch | awk '{print $2}'
}

# Apt: Install {{{1
apt_install() {
  for pkg in $*; do
    apt_install_single $pkg
  done
}

apt_install_single() {
  bullet "Installing ${1}..."

  has=`apt_cache | grep "^$1$"`

  if [ "$has" != "" ]; then
    info " already installed"
  else
    sudo apt-get install -y ${1}
    rm -f /tmp/apt-cache
  fi
}

rm -f /tmp/apt_cache

apt_cache() {
  if [ ! -e /tmp/apt_cache ]; then
    dpkg --get-selections | grep 'install' | awk '{print $1}' 2>/dev/null > /tmp/apt_cache
  fi
  cat /tmp/apt_cache
}

# Apt: Update {{{1
apt_update() {
  bullet "Updating apt..."
  sudo apt-get update
  rm /tmp/apt_cache
}

# Apt: Add Repo {{{1
add_ppa() {

  bullet "Adding repository ${1}..."
  sources="/etc/apt/sources.list /etc/apt/sources.list.d/*.list"
  if [ "`grep ppa.launchpad.net/$1 $sources`" != "" ]; then
    info " already installed"
  else
    # required for add-apt-repository
    apt_install software-properties-common
    sudo add-apt-repository -y ppa:${1}
    sudo apt-get update
  fi
}

# Deb packages {{{1
install_deb() {
  bullet "Installing ${1}..."

  has=`apt_cache | grep "^$1$"`

  if [ "$has" != "" ]; then
    info " already installed"
  else
    wget $2 -O /tmp/$1.deb
    sudo dpkg -i /tmp/$1.deb
    rm -f /tmp/apt-cache
  fi
}

# make_dir {{{1
make_dir() {
  bullet "Creating directory ${1}... "
  if [ -e $1 ]; then
    info "already exists"
  else
    mkdir -p $1
    if [ $? == 0 ]; then
      success "created"
    else
      info "  trying with sudo:"
      sudo mkdir -p $1
      if [ $? != 0 ]; then
        error "FAILED"
        exit 1
      fi
    fi
  fi
}
