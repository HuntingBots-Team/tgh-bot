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

# Copy config.env file into the image
COPY config.env /usr/src/app/

COPY . /usr/src/app/

# Remove certain directories if necessary (adjust as needed)
RUN rm -rf py_generators config.env Dockerfile LICENSE README.md requirements.txt

CMD ["bash", "start.sh"]
