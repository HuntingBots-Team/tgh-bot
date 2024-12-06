#!/bin/bash

# Activate the virtual environment
source /usr/src/app/botenv/bin/activate

# Source the environment variables from config.env
if [ -f /usr/src/app/config.env ]; then
  export $(cat /usr/src/app/config.env | xargs)
else
  echo "config.env file not found!"
  exit 1
fi

# Run the update script
python /usr/src/app/update.py

# Run the tghbot module
python3 -m tghbot
