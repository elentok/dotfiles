#!/bin/bash

echo ""
echo "========================================"
echo "Installing rvm requirements"
echo "========================================"
# run "rvm requirements" and you get this list of packages:
sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev \
  curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 \
  libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev \
  automake libtool bison subversion

#sudo apt-get install -y libreadline-gplv2-dev libreadline-dev
sudo apt-get install -y libreadline-dev

echo ""
echo "========================================"
echo "Installing RVM"
echo "========================================"
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

. $HOME/.rvm/scripts/rvm

echo "========================================"
echo "Installing Ruby 1.9.3"
echo "========================================"

rvm install 1.9.3
rvm use --default 1.9.3

echo "========================================"
echo "Installing Rails"
echo "========================================"
gem install rails

echo "========================================"
echo "Installing Nokogiri Gem + prerequisits"
echo "========================================"
sudo apt-get install -y libxslt1-dev libxml2-dev
gem install nokogiri

./post-install.sh

echo "========================================"
echo "Installing PhantomJS"
echo "========================================"
cd ~/Downloads
wget http://phantomjs.googlecode.com/files/phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2
tar xjvf phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2
sudo mv phantomjs-1.6.0-linux-x86_64-dynamic /opt/phantomjs
sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/

#sudo apt-add-repository -y ppa:antono/phantomjs
#sudo apt-get update

