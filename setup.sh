#!/bin/bash

mkdir temp
cd temp

sudo apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm unrar regexxer

# Music Player Daemon
sudo apt-get install mpd mpc ncmpc pms ncmpc-lyrics

# KDE Mpd Plasma Client
hg clone http://bitbucket.org/memnek/mpd-plasma-client/
plasmapkg -i mpd-plasma-client

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
sudo sh -c 'echo "deb http://dl.google.com/linux/talkplugin/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install google-talkplugin google-chrome-stable
sudo apt-get -f install
sudo apt-get install google-talkplugin google-chrome-stable

# Handbrake (Video converter)

sudo add-apt-repository ppa:stebbins/handbrake-snapshots 
sudo apt-get update
sudo apt-get install handbrake

# Java
sudo add-apt-repository ppa:ferramroberto/java
sudo apt-get update
sudo apt-get install sun-java6-jdk sun-java6-plugin

# Unity-LIke Launcher for KDE

sudo add-apt-repository ppa:gnumdk/ppa
sudo apt-get update
sudo apt-get install plasma-widget-icon-tasks

# Sublime Text

sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get install sublime-text-2
# Coffeescript for Sublime Text
wget https://github.com/HenriMorlaye/Coffeescript-package-for-Sublime-Text/zipball/master
mv master coffeescript.zip
mkdir -p ~/.config/sublime-text-2/Packages/CoffeeScript
unzip -j coffeescript.zip -d ~/.config/sublime-text-2/Packages/CoffeeScript


