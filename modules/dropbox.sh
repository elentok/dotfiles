#!/bin/bash

echo ""
echo "========================================"
echo "Installing Google Chrome + Google Talk Plugin"
echo "========================================"

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

