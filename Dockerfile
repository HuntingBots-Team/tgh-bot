# Use an official Python runtime as a parent image
FROM python:3.12.1-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Ensure necessary directories are created
RUN mkdir -p myjd py_generators qBittorrent/config sabnzbd sabnzbdapi tghbot web

# Update pip
RUN python3 -m pip install -U pip

# Install gnupg and add repository for sabnzbdplus
RUN apt-get update && apt-get install -y gnupg && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A0E6E3A6 && echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/sabnzbdplus.list

# Install system dependencies
RUN apt-get update && apt-get install -y git curl aria2 qbittorrent-nox sabnzbdplus

# Create and activate virtual environment
RUN python -m venv botenv

# Install any needed packages specified in requirements.txt
RUN botenv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the SABnzbd.ini file if it exists
COPY sabnzbd/SABnzbd.ini /app/sabnzbd/SABnzbd.ini

# Verify installations
RUN git --version && curl --version && aria2c --version && qbittorrent-nox --version && sabnzbdplus --version

# Activate virtual environment and start the bot
CMD ["bash", "start.sh"]
