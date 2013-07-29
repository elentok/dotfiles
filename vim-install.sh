#!/bin/bash

mkdir ~/.dotfiles
cd ~/.dotfiles
tar xzvf ~/vim-*.tar.gz
cd ~/.dotfiles/vim
./install.sh symlinks
