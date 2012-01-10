#!/bin/sh

# ========================================
# Install Music Player Daemon + Clients
apt-get install mpd mpc ncmpcpp ncmpc-lyrics

# ========================================
# Create Symlinks & Directories
mkdir ~/.mpd
mkdir ~/.mpd/playlists/
mkdir ~/.mpd/var/
mkdir ~/.mpd/var/tag_cache
ln -s `pwd`/mpd.conf ~/.mpd/mpd.conf

