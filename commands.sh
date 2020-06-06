#!/bin/bash

mkdir -p $DIR

# ALIAS:    kicad-erc, kicad-drc
function report() {
    kicad-erc
    kicad-drc
}

# ALIAS:    kiplot-gerber, kiplot-position, kiplot-drills
function fabrication() {
    kiplot-gerber 
    kiplot-position 
    kiplot-drills
}

# IN:       $BOARD $DIR
# OUT:      $DIR/*.pdf
function board() {
    kiplot -b $BOARD -c /opt/kiplot/docs.pdf.yaml -d $DIR
#    kiplot -b $BOARD -c /opt/kiplot/docs.svg.yaml -d $DIR
}

# ALIAS:    kicad-schematic
function schematic() {
    kicad-schematic
}

# ALIAS:    kicad-schematic-svg, kicad-schematic-pdf
function kicad-schematic() {
    kicad-schematic-svg 
    kicad-schematic-pdf
}

# IN:       $SCHEMATIC $DIR
# OUT:      $DIR/$NAME_schematic.svg
function kicad-schematic-svg() {
    eeschema_do $VERBOSE export -f svg $SCHEMATIC /tmp
    mv -f /tmp/$NAME.svg $DIR/$NAME"_schematic.svg"
}

# IN:       $SCHEMATIC $DIR
# OUT:      $DIR/$NAME_schematic.pdf
function kicad-schematic-pdf() {
    eeschema_do $VERBOSE export -f pdf $SCHEMATIC /tmp
    mv -f /tmp/$NAME.pdf $DIR/$NAME"_schematic.pdf"
}

# IN:       $SCHEMATIC $DIR
# OUT:      $DIR/$NAME.net
function kicad-netlist() {
    eeschema_do $VERBOSE netlist $SCHEMATIC $DIR
}

# ALIAS:    kicad-erc
function erc() {
    kicad-erc
}

# IN:       $SCHEMATIC $DIR
# OUT:      $DIR/$NAME.erc
function kicad-erc() {
    eeschema_do $VERBOSE run_erc $SCHEMATIC $DIR
}

# ALIAS:    kicad-drc
function drc() {
    kicad-drc
}

# IN:       $BOARD $DIR
# OUT:      $DIR/$NAME.rpt
function kicad-drc() {
    pcbnew_do $VERBOSE run_drc $BOARD $DIR
}

# ALIAS:    kicad-bom, ibom, kicost
function bom() {
    kicad-bom
    ibom
    kicost
}

# IN:       $SCHEMATIC $PROJECT $DIR
# OUT:      $DIR/$NAME.csv
function kicad-bom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
    rm -f $DIR/$NAME.xml
}

# IN:       $BOARD $DIR
# OUT:      $DIR/$NAME_board.pdf
function kicad-board() {
    pcbnew_do $VERBOSE export $BOARD $DIR Dwgs.User Cmts.User Eco*.User
}

# STATUS:   NOT WORKING
# IN:       $SCHEMATIC $PROJECT $DIR
# OUT:      $DIR/$NAME.xlsx
function kibom-xlsx() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC /tmp
    python3 -m kibom $VERBOSE -d $DIR --cfg /opt/kibom/bom.ini $DIR/$NAME.xml $DIR/$NAME.xlsx
    rm -f $NAME.xml
}

# IN:       $BOARD $DIR $PARAMETERS
# OUT:      $DIR/ibom.html
function ibom() {
    sh /opt/ibom/ibom.sh $BOARD $DIR $PARAMETERS
}

# IN:       $SCHEMATIC $DIR $PARAMETERS
# OUT:      $DIR/$NAME.xlsx
function kicost() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC /tmp
    python3 -m kicost -i $DIR/$NAME.xml -o $DIR/$NAME.xlsx $PARAMETERS
    rm -f $NAME.xml
}

# ALIAS:    kiplot-gerbers
function gerbers() {
    kiplot-gerber
}

# IN:       $BOARD $DIR
# OUT:      $DIR/$NAME*.gbr
function kiplot-gerber() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d $DIR
}

# IN:       $BOARD $DIR $MANUFACTURER
# OUT:      $DIR/$NAME-pos.csv
function kiplot-position() {
    kiplot -b $BOARD -c /opt/kiplot/position.yaml $VERBOSE -d $DIR
    if [ "$MANUFACTURER" = "jlcpcb" ]; then
        sed -i s/'Ref,Val,Package,PosX,PosY,Rot,Side'/'Designator,Value,Package,Mid X,Mid Y,Rotation,Layer'/g $DIR/*pos.csv 
    fi
    #TODO define other manufacturers
}

# IN:       $BOARD $DIR
# OUT:      $DIR/$NAME-*-drl.gbr, $DIR/$NAME-*.drl
function kiplot-drills() {
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d $DIR
}

# STATUS:   NOT WORKING
function pcbdraw-front() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        pcbdraw --libs=default --style /opt/pcbdraw/oshpark-purple.json $BOARD $DIR/"$NAME"_front.png
    else
        pcbdraw --libs=default $BOARD $DIR/"$NAME"_front.png
    fi
    #TODO define more manufacturers
}

# STATUS:   NOT WORKING
function pcbdraw-bottom() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        pcbdraw --libs=default --style /opt/pcbdraw/oshpark-purple.json -b $BOARD $DIR/"$NAME"_Bottom.png
    else
        pcbdraw --libs=default -b $BOARD $DIR/"$NAME"_Bottom.png
    fi
    #TODO define more manufacturers
}

# STATUS:   NOT WORKING
# ALIAS:    pcbdraw-bare-front, pcbdraw-bare-bottom
function pcbdraw-bare() {
    pcbdraw-bare-front
    pcbdraw-bare-bottom
}

# STATUS:   NOT WORKING
function pcbdraw-bare-front() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        pcbdraw --filter "" --style /opt/pcbdraw/oshpark-purple.json $BOARD $DIR/$NAME"_Bare_Top.png"
    else
        pcbdraw --filter "" $BOARD $DIR/$NAME"_Bare_Top.png"
    fi
    #TODO define more manufacturers
}

# STATUS:   NOT WORKING
function pcbdraw-bare-bottom() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        pcbdraw --filter "" --style /opt/pcbdraw/oshpark-purple.json -b $BOARD $DIR/$NAME"_Bare_Bottom.png"
    else
        pcbdraw --filter "" -b $BOARD $DIR/$NAME"_Bare_Bottom.png"
    fi
    #TODO define more manufacturers
}

function tracespace-board() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -L --out=/tmp /tmp/*Edge_Cuts.gbr /tmp/*.drl /tmp/*Mask.gbr /tmp/*SilkS.gbr /tmp/*Cu.gbr
    mv -f /tmp/$NAME*top*.svg $DIR/$NAME"_Board_Top.svg"
    mv -f /tmp/$NAME*bottom*.svg $DIR/$NAME"_Board_Bottom.svg"
}

function tracespace-assembly() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -B --out=/tmp /tmp/*Fab.gbr
    mv -f /tmp/$NAME*F_Fab*.svg $DIR/$NAME"_Assembly_Top.svg"
    mv -f /tmp/$NAME*B_Fab*.svg $DIR/$NAME"_Assembly_Bottom.svg"
}

# ALIAS:    kikit-panelize, kikit-gerber
function kikit-panel() {
    kikit-panelize
    kikit-gerber
}

# STATUS:   NOT TESTED
function kikit-panelize() {
    mkdir -p $DIR/panel

    if [ "$MANUFACTURER" = "jlcpcb" ]; then
        # TODO: auto size panel according max panel size from manufacturer
        kikit panelize grid --vcuts --panelsize 100 100 $BOARD $DIR/$NAME"_panel.kicad_pcb"
    else
        kikit panelize grid $PARAMETERS $BOARD $DIR/panel/$NAME"_panel.kicad_pcb"
    fi
}

# STATUS:   NOT TESTED
function kikit-gerber() {
    kikit export gerber $DIR/panel/$NAME"_panel.kicad_pcb"
}

#execute function
$1