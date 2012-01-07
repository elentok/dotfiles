#!/bin/bash

# bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

sudo apt-get install libreadline-dev

rvm pkg install zlib
rvm pkg install readline
rvm install 1.9.3 --with-readline-dir=$rvm_path/usr
rvm use --default 1.9.3
gem install rails
gem install nokogiri
gem install clipboard
