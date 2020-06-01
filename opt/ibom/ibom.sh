#!/bin/bash

# Start Xvfb
Xvfb :99 -ac -nolisten tcp &
xvfb=$!

export DISPLAY=:99

python3 /opt/ibom/generate_interactive_bom.py $1 --highlight-pin1 --no-browser --dest-dir=$2