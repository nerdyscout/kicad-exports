#!/bin/bash

INODE_NUM=`ls -ali / | sed '2!d' |awk {'print $1'}`
#if [ `basename $0 .sh` == 'kicad-exports' ]
if [ $INODE_NUM == '2' ];
then
    echo "running OUTSIDE docker..."
    docker run -it \
        --volume $PWD:/mnt \
        kicad-exports $@

else
    echo "running INSIDE docker..."

    export DIR="${2:-$PWD}"
    export SCHEMATIC="${3:-$(ls -1 *.sch)}"
    export BOARD="${4:-$(ls -1 *.kicad_pcb)}"
    export PROJECT="${5:-$(ls -1 *.pro)}"
    export NAME="$(basename -s .pro $PROJECT)"
    export MANUFACTURER="$6"
    export PARAMETERS="$7"
    export VERBOSE=-v

    if [ -n "$VERBOSE" ]; then
        echo "DIR=$DIR"
        echo "SCHEMATIC=$SCHEMATIC"
        echo "BOARD=$BOARD"
        echo "PROJECT=$PROJECT"
        echo "NAME=$NAME"
        echo "MANUFACTURER=$MANUFACTURER"
        echo "PARAMETERS=$PARAMETERS"
        echo "VERBOSE=$VERBOSE"

        echo $DIR
        ls -la $DIR
    fi

    /commands.sh $1
fi