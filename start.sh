#!/bin/bash

# Create and set permissions for required directories
mkdir -p /usr/src/app/data/sabnzbd
mkdir -p /usr/src/app/data/aria2
mkdir -p /usr/src/app/data/qbittorrent
mkdir -p /usr/src/app/downloads/incomplete
mkdir -p /usr/src/app/downloads/complete

# Set proper permissions
chmod -R 777 /usr/src/app/data
chmod -R 777 /usr/src/app/downloads

# Kill any existing processes
pkill -f qbittorrent-nox
pkill -f sabnzbdplus
pkill -f aria2c
sleep 2

# Clean up any lock files
rm -f /root/.config/qBittorrent/qBittorrent.lock
rm -f /root/.config/qBittorrent/lockfile
rm -f /usr/src/app/data/sabnzbd/*.lock

# Start required services
bash aria-nox-nzb.sh

# Give services more time to initialize fully
sleep 15

# Update and start the bot
python3 update.py && python3 -m tghbot
