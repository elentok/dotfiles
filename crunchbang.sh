#!/bin/sh

sudo apt-get install vim-gtk zsh krusader exuberant-ctags

# Oh My Zsh
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# RVM
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
source "/home/david/.rvm/scripts/rvm"  # This loads RVM into a shell session.
echo 'source "/home/david/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> ~/.zshrc

rvm pkg install zlib
rvm install 1.9.2 --with-zlib-dir=$rvm_path/usr
rvm default 1.9.2

rvm install rails
