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
    timeout 1 bash -c ">/dev/tcp/localhost/$1" >/dev/null 2>&1
    return $?
}

# Function to wait for a service to be ready
wait_for_service() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1

    while ! is_port_in_use "$port" && [ $attempt -le $max_attempts ]; do
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
mkdir -p /usr/src/app/downloads/incomplete
mkdir -p /usr/src/app/downloads/complete

if [ ! -f "/usr/src/app/data/sabnzbd/sabnzbd.ini" ]; then
    log_msg "Initializing SABnzbd configuration..."
    cat > /usr/src/app/data/sabnzbd/sabnzbd.ini << EOF
[misc]
host = 0.0.0.0
port = 8070
host_whitelist = *
api_key = 1234567890
username = 
password = 
download_dir = /usr/src/app/downloads/incomplete
complete_dir = /usr/src/app/downloads/complete
auto_browser = 0
check_new_rel = 0
replace_spaces = 1
web_dir = Glitter
url_base = 
enable_https = 0
https_port = 9090
https_cert = server.cert
https_key = server.key
https_chain = 
language = en
web_color = Default
web_color2 = Dark

[server-main]
host = localhost
port = 8070
timeout = 60
username = 
password = 
connections = 8
ssl = 0
enable = 1
optional = 0
retention = 0
EOF
fi

# Start SABnzbd with proper permissions
chmod 777 /usr/src/app/data/sabnzbd/sabnzbd.ini
sabnzbdplus -b 0 -f /usr/src/app/data/sabnzbd/sabnzbd.ini -s 0.0.0.0:8070 -l 0

# Wait for SABnzbd to fully initialize
log_msg "Waiting for SABnzbd API to be ready..."
max_attempts=30
attempt=1
while [ $attempt -le $max_attempts ]; do
    if curl -s "http://localhost:8070/api?mode=version&output=json&apikey=1234567890" | grep -q "version"; then
        log_msg "SABnzbd API is ready"
        break
    fi
    log_msg "Waiting for SABnzbd API (attempt $attempt/$max_attempts)..."
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    log_msg "ERROR: SABnzbd API failed to respond after $max_attempts attempts"
    exit 1
fi

log_msg "All services started successfully"
