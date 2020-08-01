#!/bin/sh

while getopts 'b:e:c:d:v' param
do
case $param in
    b) BOARD="-b $OPTARG";;
    e) SCHEMA="-e $OPTARG";;
    c) CONFIG="$OPTARG" ;;
    d) DIR="-d $OPTARG";;
esac
done

if [ -d .git ]; then
    python3 /opt/git-filters/kicad-git-filters.py
fi

if [ -f $CONFIG ]; then
    kiplot $BOARD $SCHEMA $DIR $VERBOSE -c $CONFIG
elif [ -f "/opt/kiplot/docs/samples/$CONFIG" ]; then
    kiplot $BOARD $SCHEMA $DIR $VERBOSE -c "/opt/kiplot/docs/samples/$CONFIG"
else
    echo "config file not found! please pass own file or choose from:"
    ls -1 /opt/kiplot/docs/samples/*.yaml
fi 