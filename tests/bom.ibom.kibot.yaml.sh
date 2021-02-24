#!/bin/sh


testFileGenerated() {
  FILE="$OUTPUT/docs/bom/$PROJECT-ibom.html"

  FILE_DATE=$(date -r $FILE "+%m-%d-%Y")
  SYSTEM_DATE=$(date "+%m-%d-%Y")

  # file exists
  assertTrue=$(test -f $FILE)

  # file updated
  assertEquals="$SYSTEM_DATE" "$FILE_DATE"
}

# Load shUnit2
. shunit2
exit $?
