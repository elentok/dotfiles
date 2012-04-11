#!/bin/bash

# This script should be run directly from the online repository like this:
# curl -L https://bitbucket.org/3david/dotfiles/raw/master/online_install.sh | bash
#
# Prerequisits:
# sudo apt-get install curl

(
  mkdir -p ~/.config
  cd ~/.config

  sudo apt-get install git

  bitbucket_root="git@bitbucket.org:3david"
  if [ "`whoami`" != "david" ]; then
    bitbucket_root="https://bitbucket.org/3david"
  fi

  echo ""
  echo "========================================"
  echo "Cloning dotfiles"
  git clone $bitbucket_root/dotfiles

  echo ""
  echo "========================================"
  echo "Cloning dotvim"
  git clone $bitbucket_root/dotvim

  echo "========================================"
  echo "setting up vim"
  ./dotvim/install.sh

  echo "========================================"
  echo "setting up linux"
  (
    cd dotfiles
    ./install.sh
  )
)
