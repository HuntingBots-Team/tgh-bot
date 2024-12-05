#!/bin/bash

# Check if directories exist, if not, create them
[ ! -d "myjd" ] && mkdir myjd
[ ! -d "py_generators" ] && mkdir py_generators
[ ! -d "qBittorrent/config" ] && mkdir qBittorrent/config
[ ! -d "sabnzbd" ] && mkdir sabnzbd
[ ! -d "sabnzbdapi" ] && mkdir sabnzbdapi
[ ! -d "tghbot" ] && mkdir tghbot
[ ! -d "web" ] && mkdir web

# Activate the virtual environment
source botenv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start the bot
python3 update.py
python3 -m tghbot
