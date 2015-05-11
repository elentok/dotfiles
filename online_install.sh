#!/bin/bash

# This script should be run directly from the online repository like this:
# curl -L https://github.com/elentok/dotfiles/raw/master/online_install.sh | bash
#
# Prerequisits:
# sudo apt-get install curl

cd ~

# mac comes with a built-in git
if [ "`uname -s`" != "Darwin" ]; then
  echo "========================================"
  echo "Installing git"
  sudo apt-get install git
fi

repo_root="https://github.com/elentok/dotfiles"
if [ "$1" == "use-ssh" ]; then
  repo_root="git@github.com:elentok/dotfiles"
fi

echo "========================================"
echo "Cloning dotfiles"
git clone $repo_root .dotfiles

echo "========================================"
echo "Installing"
cd ~/.dotfiles
./scripts/dotf install
