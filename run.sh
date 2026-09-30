#!/bin/bash

# 1. Exit on error (except where explicitly allowed)
set -e

# 2. Enforce root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root. Please run using: sudo ./run.sh"
   exit 1
fi

# 3. Prevent apt from hanging on interactive prompts
export DEBIAN_FRONTEND=noninteractive

echo "Starting system update..."
apt-get update && apt-get full-upgrade -y
apt-get install python3-pip rpicam-apps libcamera-tools libcamera-apps v4l-utils libcamera-v4l2 -y

echo -e "\n=== Checking Camera Devices ==="
# 4. Prevent script failure if a camera is disconnected using || true
v4l2-ctl --list-devices || echo "Warning: No v4l2 devices found."

echo -e "\n=== Checking Video Formats ==="
v4l2-ctl -d /dev/video0 --list-formats-ext || echo "Warning: /dev/video0 not accessible."

echo -e "\n=== Listing rpicam Cameras ==="
rpicam-hello --list-camera || true

echo -e "\n=== Launching Camera Preview ==="
echo "A window should appear. (Note: This requires a connected display)."
rpicam-hello --qt-preview -t 0 || echo "Warning: Camera preview failed or no display attached."
echo -e "===============================\n"
