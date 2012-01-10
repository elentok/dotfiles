#!/bin/bash

echo "Copying custom asus script to /etc/pm/sleep.d"
cp 20_custom-asus-u35jc /etc/pm/sleep.d/20_custom-asus-u35jc

echo "Setting the script as executable"
chmod 755 /etc/pm/sleep.d/20_custom-asus-u35jc

echo "Test the suspend feature"


