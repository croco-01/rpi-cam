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

CONFIG_FILE="/boot/firmware/config.txt"

echo "=== Configuring Boot Options for Raspberry Pi 3B+ ==="
if [ -f "$CONFIG_FILE" ]; then
    # Ensure camera_auto_detect=1 is set globally
    if ! grep -q "^camera_auto_detect=" "$CONFIG_FILE"; then
        echo "camera_auto_detect=1" >> "$CONFIG_FILE"
        echo "Enabled camera_auto_detect=1"
    fi

    # Add dtoverlay=ov5647 under the [all] section so the Pi 3B+ reads it
    if ! grep -q "dtoverlay=ov5647" "$CONFIG_FILE"; then
        if grep -q "^\[all\]" "$CONFIG_FILE"; then
            # If [all] exists, insert the camera overlay right under it
            sed -i '/^\[all\]/a dtoverlay=ov5647' "$CONFIG_FILE"
            echo "Added dtoverlay=ov5647 after [all] section."
        else
            # If [all] doesn't exist, safely append it to the end of the file
            echo -e "\n[all]\ndtoverlay=ov5647" >> "$CONFIG_FILE"
            echo "Created [all] section and added dtoverlay=ov5647."
        fi
    else
        echo "dtoverlay=ov5647 is already configured in $CONFIG_FILE."
    fi
else
    echo "Warning: $CONFIG_FILE not found. Skipping configuration edits."
fi

echo -e "\n=== Starting System Update & Tool Installation ==="
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

echo "Configuration complete! If your Raspberry Pi does not detect the camera, please reboot to apply the settings."
