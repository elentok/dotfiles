#!/bin/bash

# Install Bumblebee (Nvidia Optimus support)

sudo add-apt-repository ppa:bumblebee/stable
sudo add-apt-repository ppa:ubuntu-x-swat/x-updates
sudo apt-get update

sudo apt-get install bumblebee bumblebee-nvidia
sudo usermod -a -G bumblebee $USER

# to support 32-bit apps like wine:
sudo apt-get install virtualgl-libs:i386 libgl1-mesa-glx:i386 libc6:i386
