#!/bin/bash

source `dirname $0`/../config.sh

header 'Arduino'

# Install the Arduino command line toolkit (http://inotool.org/)
pip_install ino

# Install a dumb-terminal emulator (https://code.google.com/p/picocom/)
brew_install picocom

