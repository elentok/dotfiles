#!/bin/bash

echo ""
echo "========================================"
echo "Installing LAMP (Linux Apache MySQL PHP)"
echo "========================================"
sudo apt-get install -y tasksel
sudo tasksel install lamp-server
sudo apt-get install -y php5-sqlite
sudo service apache2 restart
