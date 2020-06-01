#!/bin/bash

function schematic() {
    kicad-schematic
    mv $DIR/$NAME.pdf $DIR/$NAME"_schematic.pdf"
    mv $DIR/$NAME.pdf $DIR/$NAME"_schematic.svg"
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

#function mechanics() {
#    kiplot -b $BOARD -c /opt/kiplot/documentation.yaml -d /tmp
#    kiplot -b $BOARD -c /opt/kiplot/drills.yaml -d /tmp
#    tracespace -L /tmp/*Edge_Cuts.gbr /tmp/*PTH-drl.gbr /tmp/*Dwgs*.gbr
#}

#function documentation() {
#    schematic
#    kiplot-documentation
#    #TODO: run something to generate shiny svg from /tmp/$NAME*.gbr 
#    #eg board measurments, pinouts from comment layer etc
#}

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

function erc() {
    kicad-erc
}

function kicad-erc() {
    eeschema_do $VERBOSE run_erc $SCHEMATIC $DIR
}

function drc() {
    kicad-drc
}

function kicad-drc() {
    pcbnew_do $VERBOSE run_drc $BOARD $DIR
}

function bom() {
    kicad-bom
    ibom
    kicost
}

# dont get confused... this actually outputs a CSV
function kicad-bom() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
    rm $DIR/$NAME.xml
}

#TODO: define more sets with various layers
function kicad-board() {
    pcbnew_do $VERBOSE export $BOARD $DIR Dwgs.User Cmts.User
}

function kibom() {
    python3 -m kibom $VERBOSE -d $DIR $NAME.xml --cfg /opt/kibom/bom.ini $DIR/$NAME.xlsx
    rm $DIR/$NAME.xml
}

function ibom() {
    sh /opt/ibom/ibom.sh $BOARD $DIR
}

function kicost() {
    eeschema_do $VERBOSE bom_xml $SCHEMATIC $DIR
    python3 -m kicost -i $DIR/$NAME.xml -o $DIR/$NAME.xlsx $PARAMETERS
    rm $DIR/$NAME.xml
}

function gerbers() {
    kiplot-gerber
}

function kiplot-documentation() {
    kiplot -b $BOARD -c /opt/kiplot/documentation.yaml $VERBOSE -d $DIR
}

function kiplot-gerber() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d $DIR
}

function kiplot-position() {
    kiplot -b $BOARD -c /opt/kiplot/position.yaml $VERBOSE -d $DIR
    if [ "$MANUFACTURER" = "jlcpcb" ]; then
        sed -i s/'Ref,Val,Package,PosX,PosY,Rot,Side'/'Designator,Value,Package,Mid X,Mid Y,Rotation,Layer'/g $DIR/*pos.csv 
    fi
    # define other manufacturers
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

#fails because of "swig/python detected a memory leak of type 'DLIST_ITERATOR_WRAPPER< D_PAD > *', no destructor found."
function pcbdraw-bare() {
    pcbdraw-bare-front
    pcbdraw-bare-bottom
}

function pcbdraw-bare-front() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        # FIXME: might fail as i dont know wher the styles are located
        pcbdraw --filter "" --style oshpark-purple.json $BOARD $DIR/$NAME"_bare_front.png"
    else
        pcbdraw --filter "" $BOARD $DIR/$NAME"_bare_front.png"
    fi
}

function pcbdraw-bare-bottom() {
    if [ "$MANUFACTURER" = "oshpark" ]; then
        # FIXME: might fail as i dont know wher the styles are located
        pcbdraw --filter "" --style oshpark-purple.json -b $BOARD $DIR/$NAME"_bare_bottom.png"
    else
        pcbdraw --filter "" -b $BOARD $DIR/$NAME"_bare_bottom.png"
    fi
}

function tracespace-board() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -L /tmp/*Edge_Cuts.gbr /tmp/*.drl /tmp/*Mask.gbr /tmp/*SilkS.gbr /tmp/*Cu.gbr
    mv $NAME*top*.svg $DIR/$NAME"_Board_Top.svg"
    mv $NAME*bottom*.svg $DIR/$NAME"_Board_Bottom.svg"
}

function tracespace-assembly() {
    kiplot -b $BOARD -c /opt/kiplot/gerbers.yaml $VERBOSE -d /tmp
    kiplot -b $BOARD -c /opt/kiplot/drills.yaml $VERBOSE -d /tmp
    tracespace -B /tmp/*Fab.gbr
    mv $NAME*B_Fab*.svg $DIR/$NAME"_Assembly_Bottom.svg"
    mv $NAME*F_Fab*.svg $DIR/$NAME"_Assembly_Top.svg"
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