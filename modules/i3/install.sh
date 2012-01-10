#!/bin/bash

# ========================================
# Install i3wm
echo 'deb http://debian.sur5r.net/i3/ oneiric universe' >> /etc/apt/sources.list
apt-get update
apt-get --allow-unauthenticated install sur5r-keyring
apt-get update
apt-get install i3 feh

# ========================================
# Create symlinks
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir ~/.i3
ln -s "$DIR/config" ~/.i3/config
ln -s "$DIR/i3status.conf" ~/.i3/i3status.conf
ln -s "$DIR/i3-session" ~/.i3/i3-session

sudo cp "$DIR/i3-session.desktop" /usr/share/xsessions/
