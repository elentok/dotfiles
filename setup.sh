#!/bin/bash

sudo apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm unrar

# Music Player Daemon
sudo apt-get install mpd mpc ncmpc pms ncmpc-lyrics

# Kid3 - ID3 tag editor
sudo apt-get install kid3

# Git
sudo apt-get install git 
git config --global --add color.ui true

# Ruby
sudo apt-get install build-essential libopenssl-ruby libfcgi-dev \
  ruby irb rubygems ruby1.8-dev \
  sqlite3 libsqlite3-dev \
  libmysql-ruby libmysqlclient-dev

sudo gem install rubygems-update --no-ri --no-rdoc
sudo gem install rails --include-dependencies --no-ri --no-rdoc

# LAMP
sudo apt-get install tasksel
sudo tasksel install lamp-server
sudo apt-get install php5-sqlite
sudo service apache2 restart

# JDownloader
sudo apt-add-repository ppa:jd-team/jdownloader
sudo apt-get update
sudo apt-get install jdownloader

# Chrome + Google talk plugin

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install google-talkplugin google-chrome-stable
sudo apt-get -f install
sudo apt-get install google-talkplugin google-chrome-stable

