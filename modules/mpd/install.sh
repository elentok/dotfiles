#!/bin/bash

echo ""
echo "========================================"
echo "Installing Music Player Daemon + Clients"
echo "========================================"
sudo apt-get install -y mpd mpc ncmpcpp ncmpc-lyrics

echo "========================================"
echo "Disabling system mpd service"
echo "========================================"
sudo update-rc.d -f mpd remove

echo ""
echo "========================================"
echo "Creating mpd symlinks"
echo "========================================"


DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.mpd
mkdir -p ~/.mpd/playlists/
mkdir -p ~/.mpd/var/
touch ~/.mpd/var/tag_cache
ln -sf "$DIR/mpd.conf" ~/.mpd/mpd.conf


mkdir -p ~/.ncmpcpp
ln -sf "$DIR/ncmpcpp-config" ~/.ncmpcpp/config
