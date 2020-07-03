#!/bin/bash

mkdir -p $DIR

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.erc $DIR/$NAME.rpt
function report() {
    kicad-erc
    kicad-drc
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR $MANUFACTURER
# OUTPUT:   $DIR/$NAME*.gbr, $DIR/$NAME-*-drl.gbr, $DIR/$NAME-pos.csv, $DIR/$NAME-*.drl
function fabrication() {
    kiplot-gerber
    kiplot-position
    kiplot-drills
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/*.pdf
function board() {
    kiplot -b $BOARD -c /opt/kiplot/docs.pdf.yaml -d $DIR
#    kiplot -b $BOARD -c /opt/kiplot/docs.svg.yaml -d $DIR
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_schematic.svg $DIR/$NAME_schematic.pdf
function schematic() {
    kicad-schematic
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_schematic.svg $DIR/$NAME_schematic.pdf
function kicad-schematic() {
    kicad-schematic-svg 
    kicad-schematic-pdf
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_schematic.svg
function kicad-schematic-svg() {
    eeschema_do $VERBOSE export -f svg $SCHEMATIC /tmp
    mv -f /tmp/$NAME.svg $DIR/$NAME"_schematic.svg"
    if [ -n "$TIMESTAMP" ]; then
        sed -i -E s/"(2[0-9]{3})\/(0[1-9]|1[012])\/([123]0|[012][1-9]|31) ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])"/"$TIMESTAMP"/g $DIR/$NAME"_schematic.svg"
    fi
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_schematic.pdf
function kicad-schematic-pdf() {
    eeschema_do $VERBOSE export -f pdf $SCHEMATIC /tmp
    mv -f /tmp/$NAME.pdf $DIR/$NAME"_schematic.pdf"
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.net
function kicad-netlist() {
    eeschema_do $VERBOSE netlist $SCHEMATIC $DIR
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.erc
function erc() {
    kicad-erc
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.erc
function kicad-erc() {
    eeschema_do $VERBOSE run_erc $SCHEMATIC $DIR
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.rpt
function drc() {
    kicad-drc
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.rpt
function kicad-drc() {
    pcbnew_do $VERBOSE run_drc $BOARD $DIR
}

# REQUIRES: $SCHEMATIC $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.csv $DIR/ibom.html $DIR/$NAME.xlsx
function bom() {
    kicad-bom
    ibom
    kicost
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.csv
function kicad-bom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
    rm -f $DIR/$NAME.xml
    rm -f $NAME.xml
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_board.pdf
function kicad-board() {
    pcbnew_do $VERBOSE export $BOARD $DIR Dwgs.User Cmts.User Eco1.User Eco2.User
    mv -f $DIR/printed.pdf $DIR/$NAME"_board.pdf"
}

# STATUS:   NOT WORKING
# REQUIRES: $NAME.xml
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME.xlsx
function kibom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC /tmp
    find . -name $NAME.xml -exec mv -t /tmp {} +
    python3 -m kibom $VERBOSE -d $DIR --cfg /opt/kibom/bom.ini /tmp/$NAME.xml $DIR/$NAME.xlsx
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR $PARAMETERS
# OUTPUT:   $DIR/ibom.html
function ibom() {
    sh /opt/ibom/ibom.sh $BOARD $DIR $PARAMETERS
}

# REQUIRES: $SCHEMATIC
# OPTIONAL: $DIR $PARAMETERS
# OUTPUT:   $DIR/$NAME.xlsx
function kicost() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC /tmp
    find . -name $NAME.xml -exec mv -t /tmp {} +
    python3 -m kicost -i /tmp/$NAME.xml -o $DIR/$NAME.xlsx -w --eda kicad $PARAMETERS 
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME*.gbr
function gerbers() {
    kiplot-gerber
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME*.gbr
function kiplot-gerber() {
    kiplot -b $BOARD -c /opt/kiplot/layers.gbr.yaml $VERBOSE -d $DIR
    if [ -n "$TIMESTAMP" ]; then
        for file in $DIR/*.gbr
        do
            sed -i -E "s/([0-9]{4})-([0-9]{2})-([0-9]{2}).([0-9]{2})\:([0-9]{2})\:([0-9]{2}).*\*/$TIMESTAMP*/g" $file
        done
    fi
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME*.svg
function kiplot-svg() {
    kiplot -b $BOARD -c /opt/kiplot/layers.svg.yaml $VERBOSE -d $DIR
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR $MANUFACTURER
# OUTPUT:   $DIR/$NAME-pos.csv
function kiplot-position() {
    kiplot -b $BOARD -c /opt/kiplot/position.yaml $VERBOSE -d $DIR
    if [ "$MANUFACTURER" = "jlcpcb" ]; then
        sed -i s/'Ref,Val,Package,PosX,PosY,Rot,Side'/'Designator,Value,Package,Mid X,Mid Y,Rotation,Layer'/g $DIR/*pos.csv 
        # TODO: might be good idea to use https://github.com/matthewlai/JLCKicadTools
    fi
    #TODO define other manufacturers
}

# REQUIRES: $BOARD
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME-*-drl.gbr, $DIR/$NAME-*.drl
function kiplot-drills() {
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d $DIR
}

# REQUIRES: $BOARD 
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_Board_Top.svg $DIR/$NAME_Board_Bottom.svg
function tracespace-board() {
    kiplot -b $BOARD -c /opt/kiplot/layers.gbr.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace --out=/tmp -L /tmp/*Edge_Cuts.gbr /tmp/*.drl /tmp/*Mask.gbr /tmp/*SilkS.gbr /tmp/*Cu.gbr
    mv -f /tmp/$NAME*.top.svg $DIR/$NAME"_Board_Top.svg"
    mv -f /tmp/$NAME*.bottom.svg $DIR/$NAME"_Board_Bottom.svg"
}

# REQUIRES: $BOARD 
# OPTIONAL: $DIR
# OUTPUT:   $DIR/$NAME_Assembly_Top.svg $DIR/$NAME_Assembly_Bottom.svg
function tracespace-assembly() {
    kiplot -b $BOARD -c /opt/kiplot/layers.gbr.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace --out=/tmp -B /tmp/*Fab.gbr 
    mv -f /tmp/$NAME*F_Fab*.svg $DIR/$NAME"_Assembly_Top.svg"
    mv -f /tmp/$NAME*B_Fab*.svg $DIR/$NAME"_Assembly_Bottom.svg"
}

# STATUS:   NOT TESTED
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

# REQUIRES: $BOARD, $PARAMETERS
# OUTPUT:   diff/*
function kicad-diff(){
    if [ -n "$PARAMETERS" ]; then
        currentHash="$(git rev-parse HEAD)"
        python3 /opt/kicad-diff/kidiff_linux.py -a $currentHash -b $PARAMETERS -s Git --webserver-disable $BOARD
    fi
}

#execute function
$1