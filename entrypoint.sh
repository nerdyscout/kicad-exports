#!/bin/sh

while getopts 'c:d:b:e:v' param
do
case $param in
    c) CONFIG="$OPTARG";;
    d) DIR=$("-d $OPTARG");;
    b) BOARD=$("-b $OPTARG");;
    e) SCHEMA=$("-e $OPTARG");;
    v) VERBOSE='-v';;
esac
done

if [ -d .git ]; then
    python3 /opt/git-filters/kicad-git-filters.py
fi

CONFIG="$(echo $CONFIG | tr -d '[:space:]')" # workaround - dont know why this is neccessary
echo "CONFIG:$CONFIG"
echo "DIR:$DIR"
echo "BOARD:$BOARD"
echo "SCHEMA:$SCHEMA"

if [ -f $CONFIG ]; then
    kiplot -c $CONFIG $DIR $BOARD $SCHEMA $VERBOSE
elif [ -f "/opt/kiplot/docs/samples/$CONFIG" ]; then
    kiplot -c "/opt/kiplot/docs/samples/$CONFIG" $DIR $BOARD $SCHEMA $VERBOSE
else
    echo "config file '$CONFIG' not found! Please pass own file or choose from:"
    cd /opt/kiplot/docs/samples/
    ls -1 *.yaml
    exit 1
fi 