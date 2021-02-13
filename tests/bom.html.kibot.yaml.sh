#! /bin/sh

testFileExists() {
  FILES = test -f $OUTPUT/docs/bom/$PROJECT*.html

  assertTrue $FILES
}

# Load shUnit2.
. ./shunit2