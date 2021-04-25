#!/usr/bin/shunit2

CONFIG="config/$(basename ${1%.sh})"
SCHEMATIC=$(find . -name "*.sch")
BOARD=$(find . -name "*.kicad_pcb")
DIR="test_data/output"
FILES="$DIR/cad/test-B_Adhes.dxf \
    $DIR/cad/test-B_CrtYd.dxf \
    $DIR/cad/test-B_Cu.dxf \
    $DIR/cad/test-B_Fab.dxf \
    $DIR/cad/test-B_Mask.dxf \
    $DIR/cad/test-B_Paste.dxf \
    $DIR/cad/test-B_SilkS.dxf \
    $DIR/cad/test-Cmts_User.dxf \
    $DIR/cad/test-Dwgs_User.dxf \
    $DIR/cad/test-Eco1_User.dxf \
    $DIR/cad/test-Eco2_User.dxf \
    $DIR/cad/test-Edge_Cuts.dxf \
    $DIR/cad/test-F_Adhes.dxf \
    $DIR/cad/test-F_CrtYd.dxf \
    $DIR/cad/test-F_Cu.dxf \
    $DIR/cad/test-F_Fab.dxf \
    $DIR/cad/test-F_Mask.dxf \
    $DIR/cad/test-F_Paste.dxf \
    $DIR/cad/test-F_SilkS.dxf \
    $DIR/cad/test-Margin.dxf"

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
