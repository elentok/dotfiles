#!/bin/bash

echo ""
echo "========================================"
echo "Installing i3wm"
echo "========================================"

sudo sh -c "echo 'deb http://debian.sur5r.net/i3/ oneiric universe' >> /etc/apt/sources.list"
sudo apt-get update
sudo apt-get --allow-unauthenticated install -y sur5r-keyring
sudo apt-get update
sudo apt-get install -y i3 feh

echo ""
echo "========================================"
echo "Creating i3wm symlinks"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.i3
ln -sf "$DIR/config" ~/.i3/config
ln -sf "$DIR/i3status.conf" ~/.i3/i3status.conf
ln -sf "$DIR/i3-session" ~/.i3/i3-session

sudo cp "$DIR/i3-session.desktop" /usr/share/xsessions/
