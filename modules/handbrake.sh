#!/bin/bash

echo ""
echo "========================================"
echo "Installing Handbrake (Video Converter)"
echo "========================================"
add-apt-repository -y ppa:stebbins/handbrake-snapshots 
apt-get update
apt-get install -y handbrake
