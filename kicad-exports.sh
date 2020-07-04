#!/bin/bash

if [ `basename $0 .sh` == 'kicad-exports' ]; then
    docker run -it \
        --volume $PWD:/mnt \
        kicad-exports $@
else
    if [ -n "$1" ]; then
        export DIR="${2:-$PWD}"
        if [ -n "$3" ]; then
            export SCHEMATIC="$3"
            export NAME="$(basename -s .sch $SCHEMATIC)"
        fi
        if [ -n "$4" ]; then
            export BOARD="$4"
            export NAME="$(basename -s .kicad_pcb $BOARD)"
        fi
        export MANUFACTURER="$5"
        export PARAMETERS="$6"
        if [ -d ".git" ]; then
            export TIMESTAMP="$(git show -s --format=%cI)"
        fi
#        export VERBOSE=-v

        if [ -n "$VERBOSE" ]; then
            echo "CMD=$1"
            echo "DIR=$DIR"
            echo "SCHEMATIC=$SCHEMATIC"
            echo "BOARD=$BOARD"
            echo "MANUFACTURER=$MANUFACTURER"
            echo "PARAMETERS=$PARAMETERS"
            echo "NAME=$NAME"
            echo "VERBOSE=$VERBOSE"

            # install additional tools for debugging
            apt-get install -y recordmydesktop
        fi

        if [ -n "$SCHEMATIC" ] || [ -n "$BOARD" ]; then
            /commands.sh $1
        else
            echo "neither board nor schematic found!"
        fi

    else
        echo "kicad-exports <COMMAND> <DIR> <SCHEMATIC> <BOARD> <MANUFACTURER> <PARAMETERS>"
    fi
fi
