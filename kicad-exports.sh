#!/bin/bash

if [ `basename $0 .sh` == 'kicad-exports' ]; then
    echo "running OUTSIDE docker..."
    docker run -it \
        --volume $PWD:/mnt \
        kicad-exports $@

else
    echo "running INSIDE docker..."

    export DIR="${2:-$PWD}"
    export SCHEMATIC="${3:-$(ls -1 *.sch)}"
    export BOARD="${4:-$(ls -1 *.kicad_pcb)}"
    export MANUFACTURER="$5"
    export PARAMETERS="$6"
    export NAME="$(basename -s .kicad_pcb $BOARD)"
    export VERBOSE=-v

    if [ -n "$VERBOSE" ]; then
        echo "DIR=$DIR"
        echo "SCHEMATIC=$SCHEMATIC"
        echo "BOARD=$BOARD"
        echo "MANUFACTURER=$MANUFACTURER"
        echo "PARAMETERS=$PARAMETERS"
        echo "NAME=$NAME"
        echo "VERBOSE=$VERBOSE"

        echo $DIR
        ls -la $DIR
    fi

    /commands.sh $1
fi
