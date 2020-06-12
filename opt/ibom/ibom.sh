#!/bin/bash

# Start Xvfb
Xvfb :99 -ac -nolisten tcp &
xvfb=$!

export DISPLAY=:99

python3 /opt/ibom/generate_interactive_bom.py $1 $3 --no-browser --dest-dir=$(realpath $2)