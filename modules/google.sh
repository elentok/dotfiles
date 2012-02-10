#!/bin/bash

echo ""
echo "========================================"
echo "Installing Google Chrome + Google Talk Plugin"
echo "========================================"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sh -c 'echo "deb http://dl.google.com/linux/talkplugin/deb/ stable main" >> /etc/apt/sources.list.d/google-talkplugin.list'
apt-get update
apt-get install -y google-talkplugin google-chrome-stable
apt-get -f install
