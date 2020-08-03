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
DIR="-d ."

# Exit error code
EXIT_ERROR=1

function msg_example {
    echo -e "example: $SCRIPT -c docs.kiplot.yaml -d docs -b example.kicad_pcb -e example.sch"
}

function msg_usage {
    echo -e "usage: $SCRIPT [OPTIONS]... -c <yaml-config-file> -b <kicad-project-file>"
}

function msg_disclaimer {
    echo -e "This is free software: you are free to change and redistribute it"
    echo -e "There is NO WARRANTY, to the extent permitted by law.\n"
	echo -e "See <https://github.com/nerdyscout/kicad-exports>."
}

function msg_version {
	echo -e "kicad-exports $VERSION"
}

function msg_illegal_arg {
    echo -e "$SCRIPT: illegal option $@"
}

function msg_help {
	echo -e "Mandatory arguments:"
    echo -e "  -c, --config FILE .yaml config file"
    echo -e "  -b, --board FILE .kicad_pcb project file"
    echo -e "  -e, --schematic FILE .sch schematic file"

	echo -e "\nOptional control arguments:"
    echo -e "  -d, --dir FILE output path. Default: current dir"

	echo -e "\nMiscellanious:"
    echo -e "  -v, --verbose annotate program execution\n"
    echo -e "  -h, --help display this message and exit\n"
    echo -e "  -V, --version output version information and exit"
}

function msg_more_info {
    echo -e "Try '$SCRIPT --help' for more information."
}

function help {
    msg_usage
    echo ""
    msg_help
    echo ""
    msg_example
    echo ""
    msg_disclaimer
}

function version {
    msg_version
    echo ""
    msg_disclaimer
}

function illegal_arg {
    msg_illegal_arg "$@"
    echo ""
    msg_usage
    echo ""
    msg_example
    echo ""
    msg_more_info
}

function usage {
    msg_usage
    echo ""
    msg_more_info
}


# Ensures that the number of passed args are at least equals
# to the declared number of mandatory args.
# It also handles the special case of the -h or --help arg.
function margs_precheck {
	if [ "$1" -lt "$margs" ]; then
        if [ "$2" == "--help" ] || [ "$2" == "-h" ]; then
            help
        elif [ "$2" == "--version" ] || [ "$2" == "-V" ]; then
            version
        else
            usage
        fi
        exit $EXIT_ERROR
	fi
}

# Ensures that all the mandatory args are not empty
function margs_check {
	if [ "$#" -lt "$margs" ]; then
        usage
	    exit $EXIT_ERROR
	fi
}

function args_process {
    while [ "$1" != "" ];
    do
       case "$1" in
           -c | --config ) shift
               CONFIG="$1"
               ;;
           -b | --board ) shift
               BOARD="-b$1"
               ;;
           -e | --schematic ) shift
               SCHEMA="-e$1"
               ;;
           -d | --dir) shift
               DIR="-d$1"
               ;;
           -v | --verbose ) 
               set -x
               ;;
           -h  | --help )
               help
               exit
               ;;
           -V  | --version)
               version
               exit
               ;;
           *)                     
               illegal_arg "$@"
               exit $EXIT_ERROR
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
        kiplot "-c $CONFIG" "$DIR" "$BOARD" "$SCHEMA"
    elif [ -f "/opt/kiplot/docs/samples/$CONFIG" ]; then
        kiplot -c "/opt/kiplot/docs/samples/$CONFIG" "$DIR" "$BOARD" "$SCHEMA"
    else
        echo "config file '$CONFIG' not found! Please pass own file or choose from:"
        cd /opt/kiplot/docs/samples/
        ls -1 *.yaml
        exit 1
    fi 
}


function main {
    margs_precheck "$#" "$1"

    args_process "$@"

    run
}

# Run main
main "$@"
