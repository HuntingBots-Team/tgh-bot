# Use an official Python runtime as a parent image
FROM python:3.12.1-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Ensure necessary directories are created
RUN mkdir -p myjd py_generators qBittorrent/config sabnzbd sabnzbdapi tghbot web

# Update pip
RUN python3 -m pip install -U pip

# Install gnupg, ca-certificates, and curl
RUN apt-get update && apt-get install -y gnupg ca-certificates curl

# Add Docker's official GPG key
RUN install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install system dependencies including Docker
RUN apt-get update && apt-get install -y git curl aria2 qbittorrent-nox sabnzbdplus docker-ce docker-ce-cli containerd.io

# Create and activate virtual environment
RUN python -m venv botenv

# Install any needed packages specified in requirements.txt
RUN botenv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the SABnzbd.ini file if it exists
COPY sabnzbd/SABnzbd.ini /app/sabnzbd/SABnzbd.ini

# Verify installations
RUN git --version && curl --version && aria2c --version && qbittorrent-nox --version && sabnzbdplus --version && docker --version

# Activate virtual environment and start the bot
CMD ["bash", "start.sh"]
