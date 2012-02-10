#!/bin/bash

echo ""
echo "========================================"
echo "Installing JDownloader"
echo "========================================"
sudo apt-add-repository -y ppa:jd-team/jdownloader
sudo apt-get update
sudo apt-get install -y jdownloader
