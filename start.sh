#!/bin/bash

# Activate the virtual environment
source /usr/src/app/botenv/bin/activate

# Source the environment variables from config.env
if [ -f /usr/src/app/config.env ]; then
source /usr/src/app/config.env
else
echo "config.env file not found!"
exit 1
fi

# Run the update script
python3 /usr/src/app/update.py

# Run the tghbot module
python3 -m tghbot
