#!/bin/bash

INODE_NUM=`ls -ali / | sed '2!d' |awk {'print $1'}`
for cmd in "$@"
do
    if [ $INODE_NUM == '2' ];
    then
        echo "running OUTSIDE docker..."
        # kicad-exports $cmd
        docker run -it --volume $PWD:/mnt kicad-exports $cmd
    else
        echo "running INSIDE docker..."

        export VERBOSE=-v
        export DIR="$PWD"
        export SCHEMATIC=$(ls -1 *.sch)
        export BOARD=$(ls -1 *.kicad_pcb)
        export PROJECT=$(ls -1 *.pro)

        /functions.sh $cmd
    fi
done