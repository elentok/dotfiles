#!/bin/bash

# Before running this script add the private ssh key (ssh-add ...)

cd ~/
mkdir projects
cd projects
hg clone ssh://hg@bitbucket.org/3david/vimconfig
ln -s ~/projects/vimconfig/.vimrc ~/.vimrc
ln -s ~/projects/vimconfig/vimfiles ~/.vim

