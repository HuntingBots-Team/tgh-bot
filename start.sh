#!/bin/bash
source /usr/src/app/botenv/bin/activate
source /usr/src/app/config.env
python3 update.py
python3 -m tghbot
