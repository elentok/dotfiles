#!/bin/bash

# This script should be run directly from the online repository like this:
# curl -L https://bitbucket.org/3david/dotfiles/raw/master/online_install.sh | bash
#
# Prerequisits:
# sudo apt-get install git curl

(
  mkdir -p ~/.config
  cd ~/.config

  sudo apt-get install git curl

  echo ""
  echo "========================================"
  echo "Cloning dotfiles"
  git clone git@bitbucket.org:3david/dotfiles

  echo ""
  echo "========================================"
  echo "Cloning dotvim"
  git clone git@bitbucket.org:3david/dotvim

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
