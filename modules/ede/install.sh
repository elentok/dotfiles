#!/bin/bash

echo ""
echo "========================================"
echo "Installing Elentok Desktop Environment"
echo "========================================"
#sudo apt-get install gnome-do openbox tint2 xcompmgr

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.config/openbox
ln -sf "$DIR/openbox-rc.xml" ~/.config/openbox/rc.xml
ln -sf "$DIR/openbox-environment" ~/.config/openbox/environment
ln -sf "$DIR/tint2rc" ~/.config/tint2/tint2rc

# Install tint2 volume control
#cd ~/Downloads
#wget http://softwarebakery.com/maato/files/volumeicon/volumeicon-0.4.6.tar.gz
#tar xzvf volumeicon-0.4.6.tar.gz
#cd volumeicon-0.4.6
#sudo apt-get install libasound2-dev libgtk2.0-dev
#./configure
#make
#make install
