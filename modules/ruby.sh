#!/bin/bash

#echo ""
#echo "========================================"
#echo "Installing Ruby"
#echo "========================================"

#bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

#sudo apt-get install -y libreadline-dev

#. "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*

#echo "rvm_path=$rvm_path/usr"

#rvm pkg install zlib
#rvm pkg install readline
#rvm install 1.9.3 --with-readline-dir=$rvm_path/usr
#rvm use --default 1.9.3

#echo "========================================"
#echo "Installing Rails"
#echo "========================================"
#gem install rails

echo "========================================"
echo "Installing Nokogiri Gem + prerequisits"
echo "========================================"
sudo apt-get install -y libxslt1-dev libxml2-dev
gem install nokogiri

echo "========================================"
echo "Installing Extra Gems"
echo "========================================"
gem install clipboard
