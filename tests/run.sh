#!/bin/bash

mkdir -p tests/log

for t in tests/*.kibot.yaml.sh; do
    echo "running: $t"
    shunit2 $t > tests/log/$(basename $t).log 2>&1
    grep "FAILED" tests/log/$(basename $t).log && ERR=$?
    if [ $ERR ]; then
        cat tests/log/$(basename $t).log
        ERROR=1
    fi
done

exit $ERROR