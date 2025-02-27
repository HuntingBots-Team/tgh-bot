#!/bin/bash

# Kill any existing qBittorrent processes
pkill -f qbittorrent-nox
sleep 2

# Clean up any qBittorrent lock files
rm -f /root/.config/qBittorrent/qBittorrent.lock
rm -f /root/.config/qBittorrent/lockfile

# Start required services
bash aria-nox-nzb.sh

# Give services more time to initialize fully
sleep 10

# Disable git operations for now to avoid config.env issues
export UPSTREAM_REPO=""

# Start the bot
python3 -m tghbot
