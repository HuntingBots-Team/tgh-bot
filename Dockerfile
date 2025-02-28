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
    netcat-openbsd \
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
    # Required for SABnzbd
    par2 \
    unrar \
    p7zip-full \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/aria2c /usr/local/bin/aria2c

# Set Python path and install requirements
ENV PYTHONPATH=/usr/src/app:/usr/src/app/tghbot/plugins
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir telegraph

COPY . .

# Make scripts executable, create symlink, and install package
RUN chmod +x start.sh aria-nox-nzb.sh && \
    ln -sf /usr/src/app/tghbot/helper/ext_utils/telegraph_helper.py /usr/src/app/tghbot/helper/telegram_helper/telegraph_helper.py && \
    pip3 install -e . && \
    python3 -c "from tghbot.helper.telegram_helper.telegraph_helper import telegraph" && \
    python3 -c "from myjd import MyJdApi"

CMD ["bash", "start.sh"]
