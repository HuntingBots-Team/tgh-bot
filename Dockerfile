# Use an official Python runtime as a parent image
FROM python:3.12.1-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Ensure necessary directories are created and set permissions
RUN mkdir -p /usr/src/app && chmod 777 /usr/src/app

# Install system dependencies including gcc
RUN apt-get update && apt-get install -y gcc build-essential

# Update pip to the latest version
RUN python3 -m pip install --upgrade pip

# Copy the requirements.txt file into the image
COPY requirements.txt /usr/src/app/

# Install dependencies from requirements.txt
RUN pip install -r /usr/src/app/requirements.txt

# Create and activate virtual environment
RUN python -m venv botenv

# # Use an official Python runtime as a parent image
FROM python:3.12.1-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Ensure necessary directories are created and set permissions
RUN mkdir -p /usr/src/app && chmod 777 /usr/src/app

# Install system dependencies including gcc
RUN apt-get update && apt-get install -y gcc build-essential

# Update pip to the latest version
RUN python3 -m pip install --upgrade pip

# Copy the requirements.txt file into the image
COPY requirements.txt /usr/src/app/

# Install dependencies from requirements.txt
RUN pip install -r /usr/src/app/requirements.txt

# Create and activate virtual environment
RUN python -m venv botenv

# Copy the rest of your app's source code into the image
COPY . /usr/src/app/

# Copy config.env file into the image
COPY config.env /usr/src/app/

# Command to execute start.sh with bash
CMD ["bash", "start.sh"]
