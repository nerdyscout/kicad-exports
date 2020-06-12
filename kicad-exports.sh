#!/bin/bash

if [ `basename $0 .sh` == 'kicad-exports' ]; then
    echo "starting docker..."
    docker run -it \
        --volume $PWD:/mnt \
        kicad-exports $@
else
    export DIR="${2:-$PWD}"
    export SCHEMATIC="${3:-$(ls -1 *.sch)}"
    export BOARD="${4:-$(ls -1 *.kicad_pcb)}"
    export MANUFACTURER="$5"
    export PARAMETERS="$6"
    export NAME="$(basename -s .kicad_pcb $BOARD)"
#    export VERBOSE=-v

    if [ -n "$VERBOSE" ]; then
        echo "DIR=$DIR"
        echo "SCHEMATIC=$SCHEMATIC"
        echo "BOARD=$BOARD"
        echo "MANUFACTURER=$MANUFACTURER"
        echo "PARAMETERS=$PARAMETERS"
        echo "NAME=$NAME"
        echo "VERBOSE=$VERBOSE"
    fi

    if [ -n "$SCHEMATIC" ] || [ -n "$BOARD" ]; then
        /commands.sh $1
    else
        echo "neither board nor schematic found!"
    fi
fi