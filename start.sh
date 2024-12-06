#!/bin/bash

# Activate the virtual environment
source /usr/src/app/botenv/bin/activate

# Source the environment variables from config.env
if [ -f /usr/src/app/config.env ]; then
  export $(cat /usr/src/app/config.env | xargs)
else
  echo "config.env file not found!"
  exit 1

# Run the update script
python3 update.py
python3 -m tghbot
