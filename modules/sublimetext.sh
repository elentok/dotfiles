#!/bin/bash
# ========================================
# Sublime Text
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get install sublime-text-2

# ========================================
# Coffeescript for Sublime Text
wget https://github.com/HenriMorlaye/Coffeescript-package-for-Sublime-Text/zipball/master
mv master coffeescript.zip
mkdir -p ~/.config/sublime-text-2/Packages/CoffeeScript
unzip -j coffeescript.zip -d ~/.config/sublime-text-2/Packages/CoffeeScript

