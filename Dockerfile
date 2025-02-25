FROM ubuntu:22.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

# Install system dependencies first
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    qbittorrent-nox \
    python3-gi \
    python3-gi-cairo \
    libcairo2-dev \
    libgirepository1.0-dev \
    pkg-config \
    python3-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy tgh_env script and make it executable
COPY path/to/tgh_env /usr/local/bin/tgh_env
RUN chmod +x /usr/local/bin/tgh_env

# Run the tgh_env script
RUN /usr/local/bin/tgh_env

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
CMD ["bash", "start.sh"]
