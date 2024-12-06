#!/bin/bash
source /usr/src/app/botenv/bin/activate
python3 update.py
python3 -m tghbot
