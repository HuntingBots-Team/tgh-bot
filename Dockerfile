# Use an official Python runtime as a parent image
FROM python:3.10.4-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Ensure necessary directories are created
RUN mkdir -p myjd py_generators qBittorrent/config sabnzbd sabnzbdapi tghbot web

# Update pip
RUN python3 -m pip install -U pip

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
