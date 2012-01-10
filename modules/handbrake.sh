#!/bin/bash

echo ""
echo "========================================"
echo "Installing Handbrake (Video Converter)"
echo "========================================"
sudo add-apt-repository -y ppa:stebbins/handbrake-snapshots 
sudo apt-get update
sudo apt-get install -y handbrake-gtk handbrake-cli
