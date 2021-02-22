export TESTDATA="test_data"
export OUTPUT="output"
export SCHEMATIC="$(find $TESTDATA -name *.sch)"
export BOARD="$(find $TESTDATA -name *.kicad_pcb)"
export PROJECT="$(basename $(find $TESTDATA -name *.pro) | cut -d'.' -f 1)"

#install kicad-exports
if [ $CI ]; then
    apk add docker
    USER="user"
fi

if [ -e $SCHEMATIC ] && [ -e $BOARD ]; then
    for TEST in tests/*.kibot.yaml.sh; do
        CONFIG=$(basename ${TEST%.*})
        
        # clear all data for initial state
        if [ -d $OUTPUT/ ]; then
            rm -r $OUTPUT/
        fi

        # run kicad-export to generate data under test
        echo "./kicad-exports -v -c "config/$CONFIG" -e $SCHEMATIC -b $BOARD -d $OUTPUT"
        ./kicad-exports -c $CONFIG -e $SCHEMATIC -b $BOARD -d $OUTPUT -v

        # test generated data
        if [ -e $TEST ]; then
            ./$TEST
            ERROR=$? || $ERROR
        fi
    done
fi

exit $ERROR
