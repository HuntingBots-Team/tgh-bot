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

RUN wget https://rclone.org/install.sh
RUN bash install.sh

RUN mkdir /app/gautam
RUN wget -O /app/gautam/gclone.gz https://git.io/JJMSG
RUN gzip -d /app/gautam/gclone.gz
RUN chmod 0775 /app/gautam/gclone

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
#RUN chmod +x extract
CMD ["bash","start.sh"]
