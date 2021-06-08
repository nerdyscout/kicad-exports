#!/bin/bash
ary=()

# Script configurations
SCRIPT="kicad-exports"

# Mandatory arguments
margs=1

# Arguments and their default values
CONFIG=""
BOARD=""
SCHEMA=""
SKIP=""
DIR=""
OVERWRITE=""
VERBOSE=""
COMMIT=""
if ! [ $CI ]; then
    DISPLAY=":0"
fi

# Exit error code
EXIT_ERROR=1

function msg_example {
    echo -e "example: $SCRIPT -d docs -b example.kicad_pcb -e example.sch -c docs.kibot.yaml"
}

function msg_usage {
    echo -e "usage: $SCRIPT [OPTIONS]... -c <yaml-config-file>"
}

function msg_disclaimer {
    echo -e "This is free software: you are free to change and redistribute it"
    echo -e "There is NO WARRANTY, to the extent permitted by law.\n"
	echo -e "See <https://github.com/nerdyscout/kicad-exports>."
}

function msg_version {
	echo -e "kicad-exports version: $BUILD"
}

function msg_illegal_arg {
    echo -e "$SCRIPT: illegal option $@"
}

function msg_help {
	echo -e "Mandatory arguments:"
    echo -e "  -c, --config FILE .kibot.yaml config file"

	echo -e "\nOptional control arguments:"
    echo -e "  -d, --dir DIR output path. Default: current dir, will be used as prefix of dir configured in config file"
    echo -e "  -b, --board FILE .kicad_pcb board file. Default: first board file found in current folder."
    echo -e "  -e, --schema FILE .sch schematic file. Default: first schematic file found in current folder."
    echo -e "  -s, --skip Skip preflights, comma separated or 'all'"
    echo -e "  -o, --overwrite parameter of config file key=value"

	echo -e "\nMiscellaneous:"
    echo -e "  -v, --verbose annotate program execution"
    echo -e "  -x, --diff HASH output differntial files"
    echo -e "  -h, --help display this message and exit"
    echo -e "  -V, --version output version information and exit"
}

function msg_more_info {
    echo -e "Try '$SCRIPT --help' for more information."
}

function helpme {
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
            helpme
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

function add_config {
    if [ -f $1 ]; then
        ary+=("-c $1")
    elif [ -f "/opt/kibot/config/$1" ]; then
        ary+=("-c /opt/kibot/config/$1")
    else
        echo "config file '$1' not found! Please pass own file or choose from:"
        ls /opt/kibot/config/*.yaml
        exit $EXIT_ERROR
    fi
}

function args_process {
    while [ -n "$1"  ]; do
        case "$1" in
            -c | --config ) shift
                if [[ "$1" == *.kibot.yml || "$1" == *.kibot.yaml ]]; then
                    # only one config given
                    add_config "$1"

                    # multiple configs given
                    while [[ "$2" == *.kibot.yml || "$2" == *.kibot.yaml ]]; do
                        add_config "$2"
                        shift
                    done
                elif [[ "$1" == *.kibot.lst ]]; then
                    for CONFIG in $(cat $1) ; do
                        add_config $CONFIG
                    done
                fi
                ;;
            -b | --board ) shift
                if [ -f $1 ]; then
                    BOARD="-b $1"
                elif [ -z $1 ]; then
                    BOARD=""
                else
                    echo "error: board $1 does not exist"
                    exit $EXIT_ERROR
                fi
                ;;
            -e | --schematic ) shift
                if [ -f $1 ]; then
                    SCHEMA="-e $1"
                elif [ -z $1 ]; then
                    SCHEMA=""
                else
                    echo "error: schmatic $1 does not exist"
                    exit $EXIT_ERROR
                fi
                ;;
            -d | --dir) shift
                DIR="$1"
                ;;
            -s | --skip) shift
                SKIP="-s $1"
                ;;
            -o | --overwrite) shift
                OVERWRITE="-g $1"
                ;;
            -x | --diff) shift
                COMMIT="$1"
                ;;
            -v | --verbose)
                if [ $CI ]; then
                    shift
                    if [ "$1" == "1" ]; then
                        VERBOSE="-v"
                    elif [ "$1" == "2" ]; then
                        VERBOSE="-vv"
                    elif [ "$1" == "3" ]; then
                        VERBOSE="-vvv"
                    elif [ "$1" == "4" ]; then
                        VERBOSE="-vvvv"
                    else 
                        VERBOSE=""
                    fi
                else
                VERBOSE="-v"
                fi
                ;;
            -vv )
                VERBOSE="-vv"
                ;;
            -vvv )
                VERBOSE="-vvv"
                ;;
            -vvvv )
                VERBOSE="-vvvv"
                ;;
            -h | --help )
                helpme
                exit
                ;;
            -V | --version)
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
    if [ -d .git ]; then
        # kicad-git-filters - https://github.com/INTI-CMNB/kicad-git-filters/
        filter="/opt/git-filters/kicad-git-filters.py"
        if [ -f $filter ]; then
            python3 $filter
        else
            echo -e "warning: $filter not found!"
            exit $EXIT_ERROR
        fi

        # kicad-diff - https://github.com/Gasman2014/KiCad-Diff
        if [ $COMMIT ]; then
            kicad_diff="/opt/kicad-diff/kidiff_linux.py"
            if git cat-file -e $COMMIT; then
                if [ -f $kicad_diff ]; then
                    $kicad_diff --display $DISPLAY -b $COMMIT --scm Git --webserver-disable $BOARD
                    if [ $DIR ]; then
                        mv -f $(dirname $BOARD"/kidiff") $DIR
                    fi
                    exit 0
                else
                    echo -e "warning: $kicad_diff not found!"
                    exit $EXIT_ERROR
                fi
            fi
        fi
    else
        if [ $COMMIT ]; then
            echo "please run from root of git repository"
        fi
    fi

    # kibot - https://github.com/INTI-CMNB/kibot
    if [ $DIR ]; then
        DIR="-d $DIR"
    fi
    for CONFIG in "${ary[@]}" ; do
        kibot $CONFIG $DIR $BOARD $SCHEMA $SKIP $OVERWRITE $VERBOSE && ERR=$?
        if [ $ERR ]; then
            EXIT_ERROR=$ERR
        fi
    done
    return $EXIT_ERROR
}

function main {
    margs_precheck "$#" "$1"
    args_process "$@" && msg_version
    run && return $?
}

# Removes quotes
args=$(xargs <<<"$@")

# Arguments as an array
IFS=' ' read -r -a args <<< "$args"

# Run main
main "${args[@]}"
