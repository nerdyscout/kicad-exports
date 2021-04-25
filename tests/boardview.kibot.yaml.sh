#!/usr/bin/shunit2

CONFIG="config/$(basename ${1%.sh})"
SCHEMATIC=$(find . -name "*.sch")
BOARD=$(find . -name "*.kicad_pcb")
DIR="test_data/output"
FILES="$DIR/docs/test-boardview.brd"

oneTimeSetUp() {
  ./kicad-exports -v -c $CONFIG -d $DIR -e $SCHEMATIC -b $BOARD
}

oneTimeTearDown() {
  rm -r $DIR
}

# file exists
testFileGenerated() {
  for f in $FILES; do
    assertTrue "file $f does not exist" "[ -r $f ]"
  done
}

# file updated
testFileUpdated() {
  SYSTEM_DATE=$(date +%y%m%d)

  for f in $FILES; do
    FILE_DATE=$(date -r $f +%y%m%d)
    assertEquals "file $f has not been updated" "$SYSTEM_DATE" "$FILE_DATE"
  done
}
