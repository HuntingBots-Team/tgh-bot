# VPS Deployment Guide

## Prerequisites

1. A VPS with:
   - Ubuntu 20.04 or later
   - At least 2GB RAM
   - Docker and Docker Compose installed

## Installation Steps

1. Install Docker and Docker Compose (if not already installed):
```bash
# Update package list
sudo apt update

# Install required packages
sudo apt install -y curl git

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

2. Clone the repository:
```bash
git clone https://github.com/yourusername/TGH_Mirror.git
cd TGH_Mirror
```

3. Set up environment variables:
```bash
# Copy example config
cp config.env.example config.env

# Edit the config file with your values
nano config.env
```

4. Create necessary directories for persistence:
```bash
mkdir -p data/aria2
mkdir -p data/qbittorrent
mkdir -p data/sabnzbd
```

5. Start the application:
```bash
docker-compose up -d
```

## Important Notes

1. The application uses host network mode for optimal performance
2. Data is persisted in the ./data directory
3. Logs can be viewed using: `docker-compose logs -f`
4. To update the application:
```bash
docker-compose down
git pull
docker-compose up -d --build
```

## Troubleshooting

1. If services fail to start:
   - Check logs: `docker-compose logs -f`
   - Ensure all required ports are available
   - Verify config.env settings

2. If download/upload issues occur:
   - Check network connectivity
   - Verify aria2c, qbittorrent, and sabnzbd are running: `docker-compose ps`
   - Check individual service logs: `docker-compose logs -f app`

3. For permission issues:
   - Ensure data directories have correct permissions
   - Run: `sudo chown -R 1000:1000 data/`