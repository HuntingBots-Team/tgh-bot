#!/bin/bash

# Function to log messages
log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if a process is running
is_running() {
    pgrep -f "$1" >/dev/null
    return $?
}

# Function to kill a process if it's running
kill_if_running() {
    if is_running "$1"; then
        log_msg "Stopping existing $1 process..."
        pkill -f "$1"
        sleep 2
        
        # Clean up qBittorrent lock files if needed
        if [ "$1" = "qbittorrent-nox" ]; then
            rm -f /root/.config/qBittorrent/qBittorrent.lock
            rm -f /root/.config/qBittorrent/lockfile
        fi
    fi
}

# Function to check if a port is in use
is_port_in_use() {
    nc -z localhost $1 >/dev/null 2>&1
    return $?
}

# Function to wait for a service to be ready
wait_for_service() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1

    while ! nc -z localhost $port && [ $attempt -le $max_attempts ]; do
        log_msg "Waiting for $service to be ready (attempt $attempt/$max_attempts)..."
        sleep 2
        attempt=$((attempt + 1))
    done

    if [ $attempt -gt $max_attempts ]; then
        log_msg "ERROR: $service failed to start after $max_attempts attempts"
        return 1
    fi

    log_msg "$service is ready"
    return 0
}

# Kill existing processes
kill_if_running "aria2c"
kill_if_running "qbittorrent-nox"
kill_if_running "sabnzbdplus"

# Start aria2c
log_msg "Fetching tracker list..."
tracker_list=$(curl -Ns https://ngosang.github.io/trackerslist/trackers_all_http.txt | awk '$0' | tr '\n\n' ',')

log_msg "Starting aria2c..."
aria2c --allow-overwrite=true \
       --auto-file-renaming=true \
       --bt-enable-lpd=true \
       --bt-detach-seed-only=true \
       --bt-remove-unselected-file=true \
       --bt-tracker="[$tracker_list]" \
       --bt-max-peers=0 \
       --enable-rpc=true \
       --rpc-listen-port=6800 \
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
       --dir=/usr/src/app/downloads

if ! wait_for_service 6800 "aria2c"; then
    exit 1
fi

# Start qBittorrent
log_msg "Starting qBittorrent..."
qbittorrent-nox --webui-port=8090 &

if ! wait_for_service 8090 "qBittorrent"; then
    exit 1
fi

# Start SABnzbd
log_msg "Starting SABnzbd..."
mkdir -p /usr/src/app/data/sabnzbd
if [ ! -f "/usr/src/app/data/sabnzbd/sabnzbd.ini" ]; then
    log_msg "Initializing SABnzbd configuration..."
    cat > /usr/src/app/data/sabnzbd/sabnzbd.ini << EOF
[misc]
host = 0.0.0.0
port = 8070
EOF
fi

sabnzbdplus -f /usr/src/app/data/sabnzbd/sabnzbd.ini -s 0.0.0.0:8070 -b 0 -d -l 0

if ! wait_for_service 8070 "SABnzbd"; then
    exit 1
fi

log_msg "All services started successfully"
