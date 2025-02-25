#!/bin/bash

# Start required services
bash aria-nox-nzb.sh

# Give services time to start
sleep 5

# Update and start the bot
python3 update.py
python3 -m tghbot