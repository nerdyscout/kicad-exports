#!/bin/bash

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

function bom() {
    kicad-bom
    ibom
    kicost
}

#TODO: this one still fails
function kicad-bom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
}

#TODO: define more sets with various layers
function kicad-board() {
    pcbnew_do $VERBOSE export $BOARD $DIR Dwgs.User Cmts.User
}

#TODO: this one still fails
function kibom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC /tmp
    python3 -m kibom $VERBOSE -d $DIR /tmp/$NAME.xml --cfg /opt/kibom/bom.ini $DIR/$PROJECT.xlsx
}

function ibom() {
    sh /opt/ibom/ibom.sh $BOARD $DIR
}

#FIXME
function kicost() {
    python3 -m kicost -i $DIR/$NAME.xml -o $DIR/$NAME.xlsx --include digikey farnell
}

function gerbers() {
    kiplot-gerber
}

function kiplot-gerber() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d $DIR
}

function kiplot-position() {
    kiplot -b $BOARD -c /opt/kiplot/position.yaml $VERBOSE -d $DIR
    if [ "$MANUFACTURER" = "jlcpcb" ]; then
        sed s/'Ref,Val,Package,PosX,PosY,Rot,Side'/'Designator,Value,Package,Mid X,Mid Y,Rotation,Layer'/g $DIR/*pos.csv
    fi
}

function kiplot-drills() {
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d $DIR
}

function pcbdraw-front() {
#    if [ "$MANUFACTURER" = "oshpark" ]; then
# TODO:
# generate purple pcb
#    else
        pcbdraw $BOARD $DIR/"$NAME"_front.png
#    fi
}

function pcbdraw-bottom() {
# TODO:
#    if [ "$MANUFACTURER" = "oshpark" ]; then
# TODO:
# generate purple pcb
#    else
        pcbdraw -b $BOARD $DIR/"$NAME"_bottom.png
#    fi
}

function pcbdraw-bare() {
    pcbdraw-bare-front
    pcbdraw-bare-bottom
}

function pcbdraw-bare-front() {

#    if [ "$MANUFACTURER" = "oshpark" ]; then
# TODO:
# generate purple pcb
#    else
        pcbdraw --filter "" $BOARD $DIR/$NAME"_bare_front.png"
#    fi
}

function pcbdraw-bare-bottom() {
#    if [ "$MANUFACTURER" = "oshpark" ]; then
# TODO:
# generate purple pcb
#    else
        pcbdraw --filter "" -b $BOARD $DIR/$NAME"_bare_bottom.png"
#    fi
}

function tracespace-board() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -L /tmp/*Edge_Cuts.gbr /tmp/*.drl /tmp/*Mask.gbr /tmp/*SilkS.gbr /tmp/*Cu.gbr
    mv $NAME*top*.svg $DIR/$NAME"_Top_Board.svg"
    mv $NAME*bottom*.svg $DIR/$NAME"_Bottom_Board.svg"
}

function tracespace-assembly() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -B /tmp/*Fab.gbr
    mv $NAME*B_Fab*.svg $DIR/$NAME"_Bottom_Assembly.svg"
    mv $NAME*F_Fab*.svg $DIR/$NAME"_Top_Assembly.svg"
}

function kikit-panelize() {
# TODO:
#    if [ "$MANUFACTURER" = "jlcpcb" ]; then
#        kikit panelize grid $PARAMETER $BOARD $DIR/$NAME"_panel.kicad_pcb"
        kikit panelize grid --gridsize 3 5 --vcuts --panelsize 100 100 $BOARD $DIR/$NAME"_panel.kicad_pcb"
#    else
#        kikit panelize grid PARAMETERS $BOARD $DIR/$NAME"_panel.kicad_pcb"
#    fi
}

function kikit-gerber() {
    kikit export gerber $DIR/$BOARD
}

function kikit-dxf() {
    kikit export dxf $DIR/$BOARD
}

#execute function
$1