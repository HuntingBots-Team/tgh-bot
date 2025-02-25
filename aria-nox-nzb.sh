#!/bin/bash

# Function to log messages
log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if a command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_msg "ERROR: $1 command not found"
        return 1
    fi
    return 0
}

# Check required commands
for cmd in curl aria2c qbittorrent-nox sabnzbdplus; do
    if ! check_command $cmd; then
        log_msg "Critical dependency $cmd is missing. Exiting."
        exit 1
    fi
done

# Start aria2c
log_msg "Fetching tracker list..."
tracker_list=$(curl -Ns https://ngosang.github.io/trackerslist/trackers_all_http.txt | awk '$0' | tr '\n\n' ',')
if [ $? -ne 0 ]; then
    log_msg "Warning: Failed to fetch tracker list, using default configuration"
    tracker_list=""
fi

log_msg "Starting aria2c..."
aria2c --allow-overwrite=true \
       --auto-file-renaming=true \
       --bt-enable-lpd=true \
       --bt-detach-seed-only=true \
       --bt-remove-unselected-file=true \
       --bt-tracker="[$tracker_list]" \
       --bt-max-peers=0 \
       --enable-rpc=true \
       --rpc-max-request-size=1024M \
       --max-connection-per-server=10 \
       --max-concurrent-downloads=1000 \
       --split=10 \
       --seed-ratio=0 \
       --check-integrity=true \
       --continue=true \
       --daemon=true \
       --disk-cache=40M \
       --force-save=true \
       --min-split-size=10M \
       --follow-torrent=mem \
       --check-certificate=false \
       --optimize-concurrent-downloads=false \
       --http-accept-gzip=true \
       --max-file-not-found=0 \
       --max-tries=20 \
       --peer-id-prefix=-qB4650- \
       --reuse-uri=true \
       --content-disposition-default-utf8=true \
       --user-agent=Wget/1.12 \
       --peer-agent=qBittorrent/4.6.5 \
       --quiet=true \
       --summary-interval=0 \
       --max-upload-limit=1K \
       --save-session=/usr/src/app/data/aria2/aria2.session \
       --save-session-interval=60 \
       --dir=/usr/src/app/data/aria2/downloads

if [ $? -ne 0 ]; then
    log_msg "ERROR: Failed to start aria2c"
    exit 1
fi

# Wait for aria2c to be ready
sleep 2

# Start qBittorrent
log_msg "Starting qBittorrent..."
qbittorrent-nox -d --profile="/usr/src/app/data/qbittorrent"
if [ $? -ne 0 ]; then
    log_msg "ERROR: Failed to start qBittorrent"
    exit 1
fi

# Wait for qBittorrent to be ready
sleep 2

# Start SABnzbd
log_msg "Starting SABnzbd..."
if [ ! -f "/usr/src/app/data/sabnzbd/sabnzbd.ini" ]; then
    log_msg "Initializing SABnzbd configuration..."
    mkdir -p /usr/src/app/data/sabnzbd
fi

sabnzbdplus -f /usr/src/app/data/sabnzbd/sabnzbd.ini -s 0.0.0.0:8070 -b 0 -d -l 0
if [ $? -ne 0 ]; then
    log_msg "ERROR: Failed to start SABnzbd"
    exit 1
fi

log_msg "All services started successfully"