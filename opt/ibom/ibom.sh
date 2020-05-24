#!/bin/bash

# Start Xvfb
Xvfb :99 -ac -nolisten tcp &
xvfb=$!

export DISPLAY=:99

python3 /opt/InteractiveHtmlBom/generate_interactive_bom.py $1 --include-tracks --highlight-pin1 --no-browser --dest-dir=$2