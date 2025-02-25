FROM ubuntu:22.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

# Create necessary directories
RUN mkdir -p /usr/src/app/sabnzbd \
    && mkdir -p /usr/src/app/data/aria2 \
    && mkdir -p /usr/src/app/data/qbittorrent \
    && mkdir -p /usr/src/app/data/sabnzbd

# Install system dependencies first
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 \
    python3-pip \
    curl \
    aria2 \
    git \
    qbittorrent-nox \
    sabnzbdplus \
    # Required for PyGObject and related packages
    python3-gi \
    python3-gi-cairo \
    libcairo2-dev \
    libgirepository1.0-dev \
    pkg-config \
    python3-dev \
    # Required for dbus-python
    libdbus-1-dev \
    libdbus-glib-1-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/aria2c /usr/local/bin/aria2c

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Make scripts executable
RUN chmod +x start.sh aria-nox-nzb.sh

CMD ["bash", "start.sh"]