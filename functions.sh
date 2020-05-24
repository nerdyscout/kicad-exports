#!/bin/bash

function schematic() {
    kicad-schematic
}
function kicad-schematic() {
    kicad-schematic-svg
    kicad-schematic-pdf
}
function kicad-schematic-svg() {
    eeschema_do $VERBOSE export -f svg $SCHEMATIC $DIR
}
function kicad-schematic-pdf() {
    eeschema_do $VERBOSE export -f pdf $SCHEMATIC $DIR
}

function schematic() {
    kicad-schematic
}
function report() {
    kicad-erc
    kicad-drc
}
function fabrication() {
    kiplot-gerber 
    kiplot-position 
    kiplot-drills
}

function kicad-schematic() {
    kicad-schematic-svg 
    kicad-schematic-pdf
}
function kicad-schematic-svg() {
    eeschema_do $VERBOSE export -f svg $SCHEMATIC $DIR
}
function kicad-schematic-pdf() {
    eeschema_do $VERBOSE export -f pdf $SCHEMATIC $DIR
}
function kicad-netlist() {
    eeschema_do $VERBOSE netlist $SCHEMATIC $DIR
}

function kicad-erc() {
    eeschema_do $VERBOSE run_erc $SCHEMATIC $DIR
}
function kicad-drc() {
    pcbnew_do $VERBOSE run_drc $BOARD $DIR
}
#TODO: this one still fails
function kicad-bom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
}
#TODO: define more sets with various layers
function kicad-board() {
    pcbnew_do $VERBOSE export $BOARD $DIR Dwgs.User Cmts.User
}

function kibom() {
    python3 -m kibom $VERBOSE -d $DIR $PROJECT.xml $DIR/$PROJECT.xlsx
}

function ibom() {
    sh /opt/InteractiveHtmlBom/ibom.sh $BOARD $DIR
}

function kicost() {
    python3 -m kicost -i $PROJECT.xml -o $DIR/$PROJECT.xlsx --include digikey farnell
}

function gerbers() {
    kiplot-gerber
}

function kiplot-gerber() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d $DIR
}

function kiplot-position() {
    kiplot -b $BOARD -c /opt/kiplot/position.yaml $VERBOSE -d $DIR
}
function kiplot-drills() {
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d $DIR
}

function pcbdraw-front() {
    pcbdraw $BOARD $DIR/"$PROJECT"_front.png
}
function pcbdraw-bottom() {
    pcbdraw -b $BOARD $DIR/"$PROJECT"_bottom.png
}
function pcbdraw-bare-front() {
    pcbdraw --filter "" $BOARD_FILE $DIR/"$PROJECT"_bare_front.png
}
function pcbdraw-bare-bottom() {
    pcbdraw --filter "" -b $BOARD $DIR/"$PROJECT"_bare_bottom.png
}

function tracespace-board() {
    kiplot-gerbers && tracespace -L --out=$DIR/ $DIR/gerber/*.gbr
}
function tracespace-assembly() {
    kiplot-gerbers && tracespace -B --out=$DIR/ $DIR/gerber/*.gbr
}

function kikit-panelize() {
    kikit panelize grid $KIKIT_PARAMS $BOARD_FILE $PANEL
}

function kikit-gerber() {
    kikit export gerber $BOARD
}
function kikit-dxf() {
    kikit export dxf $BOARD
}

#execute function
$@