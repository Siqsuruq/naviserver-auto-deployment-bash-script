#!/bin/bash

echo "Stopping NaviServer service..."
sudo systemctl stop naviserver
echo "Disabling NaviServer service..."
sudo systemctl disable naviserver
echo "Removing systemd service file..."
sudo rm /etc/systemd/system/naviserver.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
echo "Removing init script..."
sudo rm /etc/init.d/naviserver
sudo rm /etc/rc.d/rc.naviserver
echo "Removing PID file..."
sudo rm /opt/ns/logs/nsd.pid
echo "NaviServer and all associated files have been removed."
