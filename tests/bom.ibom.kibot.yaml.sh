#!/bin/sh

FILE="$OUTPUT/docs/bom/$PROJECT-ibom.html"
FILE_DATE=$(date -r $FILE "+%m-%d-%Y")
SYSTEM_DATE=$(date "+%m-%d-%Y")

oneTimeSetUp() {
  echo "TEST DATA"
  echo "TEST:$0"
  echo "SCHEMATIC:$SCHEMATIC"
  echo "BOARD:$BOARD"
  echo "PROJECT:$PROJECT"
  echo "OUTPUT:$OUTPUT"
  echo ""
}

# file exists
testFileGenerated() {
    assertTrue "file does not exist" "[ -r $FILE ]"
}

# file updated
testFileUpdated() {
  assertEquals "file has not been updated" "$SYSTEM_DATE" "$FILE_DATE"
}

# Load shUnit2
. shunit2
exit $?
