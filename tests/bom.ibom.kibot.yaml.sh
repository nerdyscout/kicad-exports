#!/bin/sh

testFileExists() {
  assertTrue=$(test -f $OUTPUT/docs/bom/$PROJECT-ibom.html) && echo 1 || echo 0
}

# Load shUnit2
. shunit2
exit $?
