# Raspberry Pi Setup Camera

## Prerequisites

* Raspberry Pi running Raspberry Pi OS (Bullseye or Bookworm).
* Connected and enabled Raspberry Pi Camera Module.
* Active internet connection.

## Installation & Usage

**1. Download the script**

Download the `run.sh` script to your Raspberry Pi, or create it directly using a terminal editor:
```bash
nano run.sh
```
*(Paste the script contents into the file, save, and exit).*

**2. Make the script executable**
```bash
chmod +x run.sh
```

**3. Run the setup (Root Required)**
```bash
sudo ./run.sh
```

## What to Expect During Installation

* **Camera Test:** A preview window will appear to verify hardware functionality (requires a connected display).

## If not get the Display reboot & after reboot run

```bash
rpicam-hello --qt-preview -t 0
```
