# Use an official Python runtime as a parent image
FROM python:3.10.4-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Ensure necessary directories are created
RUN mkdir -p plugins sabnzbdapi tghbot

# dor updating Old Pip 
RUN python3 -m pip install -U pip

# Create and activate virtual environment
RUN python -m venv botenv

# Install any needed packages specified in requirements.txt
RUN botenv/bin/pip install --no-cache-dir -r requirements.txt

# Activate virtual environment and start the bot
CMD ["bash", "start.sh"]
