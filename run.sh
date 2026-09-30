#!/bin/bash

# Update and upgrade system packages
sudo apt-get update && sudo apt-get full-upgrade -y

# Install necessary dependencies and camera utilities
sudo apt install python3-pip rpicam-apps libcamera-tools libcamera-apps v4l-utils libcamera-v4l2 -y

# Check camera status and formats
echo -e "\n=== Checking Camera Devices ==="
v4l2-ctl --list-devices

echo -e "\n=== Checking Video Formats (/dev/video0) ==="
v4l2-ctl -d /dev/video0 --list-formats-ext

echo -e "\n=== Listing rpicam Cameras ==="
rpicam-hello --list-camera

echo -e "\n=== Launching Camera Preview ==="
echo "A window should appear. (Note: This requires a connected display)."
rpicam-hello --qt-preview -t 0
echo -e "===============================\n"
