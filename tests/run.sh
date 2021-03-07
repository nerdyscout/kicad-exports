export TESTDATA="test_data"
export OUTPUT="$TESTDATA/tmp"
export SCHEMATIC="$(find $TESTDATA -name *.sch)"
export BOARD="$(find $TESTDATA -name *.kicad_pcb)"
#export PROJECT="$(basename $(find $TESTDATA -name *.pro) | cut -d'.' -f 1)"

#install docker to run kicad-exports
if [ $CI ]; then
    apk add docker tree
    echo "PWD: $PWD"
    cat kicad-exports
    ls -la $PWD
fi

if [ -e $SCHEMATIC ] && [ -e $BOARD ]; then
    for TEST in tests/*.kibot.yaml.sh; do
        CONFIG=$(basename ${TEST%.*})
        
        # clear all data for initial state
        if [ -d $OUTPUT/ ]; then
            rm -r $OUTPUT/
        fi

        # run kicad-export to generate data under test
        CMD="./kicad-exports -v -c config/$CONFIG -e $SCHEMATIC -b $BOARD -d $OUTPUT"
        echo "$CMD"
        $CMD && ./$TEST
        ERROR=$ERROR || $?
    done
fi

exit $ERROR
