#!/bin/bash

echo ""
echo "========================================"
echo "Installing JDownloader"
echo "========================================"
apt-add-repository -y ppa:jd-team/jdownloader
apt-get update
apt-get install -y jdownloader
