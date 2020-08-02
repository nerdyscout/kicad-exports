#!/bin/bash

# Script configurations
SCRIPT="kicad-exports"
VERSION="2.0"

# Mandatory arguments
margs=3

# Arguments and their default values
CONFIG=""
BOARD=""
SCHEMA=""
DIR="."

function example {
    echo -e "example: $SCRIPT -c docs.kiplot.yaml -d docs -b example.kicad_pcb -s example.sch"
}

function usage {
    echo -e "usage: $SCRIPT [OPTIONS]... -c <yaml-config-file> -b <kicad-project-file> \n"
    echo -e "hint: do not use globs for parameters."
}

function disclaimer {
    echo -e "This is free software: you are free to change and redistribute it"
    echo -e "There is NO WARRANTY, to the extent permitted by law.\n"
	echo -e "See <https://github.com/nerdyscout/kicad-exports>."
}

function version {
	echo -e "kicad-exports $VERSION"
}

function help {
    usage

	echo -e "\nMandatory arguments:"
    echo -e "  -c, --config FILE .yaml config file"
    echo -e "  -b, --board FILE .kicad_pcb project file"
    echo -e "  -e, --schematic FILE .sch schematic file"

	echo -e "\nOptional control arguments:"
    echo -e "  -d, --dir FILE output path. Default: current dir"

	echo -e "\nMiscellanious:"
    echo -e "  -v, --verbose annotate program execution\n"
    echo -e "  -h, --help display this message and exit\n"
    echo -e "  -V, --Version output version information and exit\n"

    example
    disclaimer
}

# Ensures that the number of passed args are at least equals
# to the declared number of mandatory args.
# It also handles the special case of the -h or --help arg.
function margs_precheck {
	if [ $2 ] && [ $1 -lt $margs ]; then
		if [ $2 == "--help" ] || [ $2 == "-h" ]; then
			help
			exit
        else
            usage
            example
            exit 1 # error
		fi
	fi
}

# Ensures that all the mandatory args are not empty
function margs_check {
	if [ $# -lt $margs ]; then
	    usage
	  	example
	    exit 1 # error
	fi
}

function args_process {
    while [ "$1" != "" ];
    do
       case $1 in
           -c | --config ) shift
               CONFIG=$1
               ;;
           -b | --board ) shift
               BOARD=$1
               ;;
           -e | --schematic ) shift
               SCHEMA=$1
               ;;
           -d | --dir) shift
               DIR=$1
               ;;
           -v | --verbose ) 
               set -x
               ;;
           -h  | --help )
               help
               disclaimer
               exit
               ;;
           -V  | --version)
               version
               disclaimer
               exit
               ;;
           *)                     
               echo "$SCRIPT: illegal option $1"
               usage
               example
               exit 1 # error
               ;;
        esac
        shift
    done
}

function run {
    CONFIG="$(echo "$CONFIG" | tr -d '[:space:]')"

    if [ -d .git ]; then
        filter="/opt/git-filters/kicad-git-filters.py"
        if [ -f $filter ]; then
            python3 $filter
        else
            echo -e "warning: $filter not found!"
        fi
    fi

    if [ -f $CONFIG ]; then
        kiplot -c "$CONFIG" -d "$DIR" -b "$BOARD" -e "$SCHEMA"
    elif [ -f "/opt/kiplot/docs/samples/$CONFIG" ]; then
        kiplot -c "/opt/kiplot/docs/samples/$CONFIG" -d "$DIR" -b "$BOARD" -e "$SCHEMA"
    else
        echo "config file '$CONFIG' not found! Please pass own file or choose from:"
        cd /opt/kiplot/docs/samples/
        ls -1 *.yaml
        exit 1
    fi 
}


function main {

    margs_precheck $# $1

    args_process "$@"

    run

}

# Run main
main "$@"

