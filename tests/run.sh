#!/bin/bash

export TESTDATA="test_data"
export SCHEMATIC=$(find $TESTDATA -name *.sch)
export BOARD=$(find $TESTDATA -name *.kicad_pcb)
export PROJECT=$(basename $(find $TESTDATA -name *.pro) | cut -d'.' -f 1)
export OUTPUT="output"

for CONFIG in config/*.kibot.yaml; do
    # run kicad-export to generate data under test
    kicad-exports -s $SCHEMATIC -b $BOARD -c $CONFIG -d $OUTPUT -v
    # test generated data
    ./tests/$CONFIG.sh $OUTPUT $PROJECT
    # clear all generated data
    rm -r $OUTPUT/*
done
