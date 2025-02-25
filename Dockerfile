FROM ubuntu:22.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

# Install system dependencies first
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    qbittorrent-nox \
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
    && rm -rf /var/lib/apt/lists/*
    
COPY requirements.txt .
RUN tgh_env/bin/pip3.12 install --no-cache-dir -r requirements.txt

COPY . .
CMD ["bash", "start.sh"]
