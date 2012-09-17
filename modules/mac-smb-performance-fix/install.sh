#!/bin/bash

echo ""
echo "========================================"
echo "Fixing SMB performance problem"
echo ""
echo "For more information about this fix, see"
echo "https://discussions.apple.com/thread/4173253?start=0&tstart=0"
echo "========================================"

sudo sysctl -w net.inet.tcp.delayed_ack=0
sudo cp sysctl.conf /etc/
