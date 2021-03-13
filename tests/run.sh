#!/bin/sh

for t in tests/*.kibot.yaml.sh
do
    echo "running: $t"
    shunit2 $t
done
exit $?
