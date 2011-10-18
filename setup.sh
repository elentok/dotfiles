#!/bin/bash

sudo apt-get install vim-gnome mercurial \
  ctags keepass2 gimp htop \
  samba libpam-smbpass \
  pysdm \
  gnome-shell compizconfig-settings-manager

sudo apt-get install git 

#sudo apt-get install xfce4-xkb-plugin xfce4-cpufreq-plugin \
#  xubuntu-restricted-extras

# Ruby

sudo apt-get install build-essential libopenssl-ruby libfcgi-dev \
  ruby irb rubygems ruby1.8-dev \
  sqlite3 libsqlite3-dev \
  libmysql-ruby libmysqlclient-dev

sudo gem install rubygems-update
sudo gem install rails --include-dependencies

# Lamp
sudo apt-get install tasksel
sudo tasksel install lamp-server
