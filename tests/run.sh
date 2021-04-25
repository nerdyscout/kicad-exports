#!/bin/bash

mkdir -p tests/log

ERROR=0
for t in tests/*.kibot.yaml.sh; do
    shunit2 $t > tests/log/$(basename $t).log 2>&1
    if [[ $(grep "failures=" tests/log/$(basename $t).log -h) ]]; then
        echo "FAILED: $t"
        cat tests/log/$(basename $t).log
        ERROR=$(echo "$ERROR+1" | bc)
    else
        echo "PASSED: $t"
    fi
done

exit $ERROR