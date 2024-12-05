#!/bin/bash

# Check if directories exist, if not, create them
[ ! -d "plugins" ] && mkdir plugins
[ ! -d "sabnzbdapi" ] && mkdir sabnzbdapi
[ ! -d "tghbot" ] && mkdir tghbot

# Activate the virtual environment
source botenv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start the bot
python tghbot/update.py
