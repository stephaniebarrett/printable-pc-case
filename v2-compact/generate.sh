#!/bin/bash

# Script to export OpenSCAD files into .stl and .png
# Copyright (C) 2023 Stephanie Barrett (https://github.com/stephaniebarrett)
# Last revised 04/01/2024

# Usage: generate.sh [OPTION [ARGUMENT]]...
#
# OPTIONS:
#    -o, --out_path <filepath>                      Specify the output file path. Default: ./export
#    -i, --in_file <filepath>                       Specify the input .scad file. Default: main.scad
#    -p, --panel front|left|right|top|bottom|back   Specify which panel to render.
#    -j, --joinery                                  A toggle to render the joinery instead of the panel for the specified panel.
#    -c, --cage                                     A toggle to render the HDD cage instead of any other geometry.
#    -r, --resolution <value>                       The resolution of the exported .png thumbnail. Default: 1024.
#    -a, --all                                      Exports all geometry. NOTE: very hardware intensive.
#    -s                                             Exports an exploded view screenshot.
#    -h, --help                                     Displays this information.

openscad="/usr/bin/openscad"
in_file="main.scad"
out_path="export"
panels=
joinery=0
resolution=1024

usage()
{
    cat <<USAGE
Usage: ${0} [OPTION [ARGUMENT]]...

OPTIONS:
    -o, --out_path <filepath>                      Specify the output file path. Default: ./export
    -i, --in_file <filename>                       Specify the input .scad file. Default: main.scad
    -p, --panel front|left|right|top|bottom|back   Specify which panel to render.
    -j, --joinery                                  A toggle to render the joinery instead of the panel for the specified panel.
    -c, --cage                                     A toggle to render the HDD cage instead of any other geometry.
    -r, --resolution <value>                       The resolution of the exported .png thumbnail. Default: 1024.
    -a, --all                                      Exports all geometry. NOTE: very hardware intensive.
    -s                                             Exports an exploded view screenshot.
    -h, --help                                     Print this help message.
USAGE
}

generate()
{
    \mkdir -p $out_path'/'$1
    if [ "$1" = "screenshot" ]
    then
        png=$out_path'/'$1'/printable-pc-case-v2.png'
        openscad -o $png -D FRONT=1 -D LEFT=1 -D RIGHT=1 -D FLOOR=1 -D ROOF=0 -D BACK=1 -D DRIVE_CAGE=1 -D JOINERY=0 -D SECTION=0 -D EXPLODED=1 --imgsize $resolution,$resolution $in_file &
    elif [ "$1" = "cage" ]
    then
        stl=$out_path'/'$1'/'$1'.stl'
        png=$out_path'/'$1'/'$1'.png'

        openscad -o $stl -D FRONT=0 -D LEFT=0 -D RIGHT=0 -D FLOOR=0 -D ROOF=0 -D BACK=0 -D DRIVE_CAGE=1 -D JOINERY=0 $in_file &
        openscad -o $png -D FRONT=0 -D LEFT=0 -D RIGHT=0 -D FLOOR=0 -D ROOF=0 -D BACK=0 -D DRIVE_CAGE=1 -D JOINERY=0 --autocenter --viewall --imgsize $resolution,$resolution $in_file &
    else
        if [ $8 -eq 0 ]
        then

            for section in 1 2 3 4
            do
                stl=$out_path'/'$1'/'$1'-'$section'.stl'
                png=$out_path'/'$1'/'$1'-'$section'.png'

                openscad -o $stl -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D DRIVE_CAGE=0 -D JOINERY=0 -D SECTION=$section -D EXPLODED=0 $in_file &
                openscad -o $png -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D DRIVE_CAGE=0 -D JOINERY=0 -D SECTION=$section -D EXPLODED=0 --autocenter --viewall --imgsize $resolution,$resolution $in_file &
            done
        else
            stl=$out_path'/'$1'/'$1'_joinery.stl'
            png=$out_path'/'$1'/'$1'_joinery.png'

            openscad -o $stl -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D DRIVE_CAGE=0 -D JOINERY=1 -D SECTION=0 -D EXPLODED=0 $in_file &
            openscad -o $png -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D DRIVE_CAGE=0 -D JOINERY=1 -D SECTION=0 -D EXPLODED=0 --autocenter --viewall --imgsize $resolution,$resolution $in_file &
        fi
    fi
}

generate_panel()
{
    case $1 in
        "front")
            generate "front" 1 0 0 0 0 0 $2
            ;;
        "left")
            generate "left" 0 1 0 0 0 0 $2
            ;;
        "right")
            generate "right" 0 0 1 0 0 0 $2
            ;;
        "floor"|"bottom")
            generate "floor" 0 0 0 1 0 0 $2
            ;;
        "roof"|"top")
            generate "roof" 0 0 0 0 1 0 $2
            ;;
        "back"|"rear")
            generate "back" 0 0 0 0 0 1 $2
            ;;
        *)
            echo "Invalid panel selection."
            exit 1
            ;;
    esac
}

generate_all()
{
    generate "screenshot"
    generate "cage"
    for i in 0 1
    do
        generate_panel "front" $i
        generate_panel "left" $i
        generate_panel "right" $i
        generate_panel "floor" $i
        generate_panel "roof" $i
        generate_panel "back" $i
        wait
    done
}

# Parse the command line arguments
while [ "$1" != "" ]; do
    case $1 in
        -o | --out_path )
            shift
            out_path=$1
            ;;
        -i | --in_file )
            shift
            in_file=$1
            ;;
        -p | --panel )
            shift
            panels+=($1)
            ;;
        -j | --joinery )
            joinery=1
            ;;
        -c | --cage )
            generate "cage"
            wait
            ;;
        -r | --resolution )
            shift
            resolution=$1
            ;;
        -a | --all )
            generate_all
            exit
            ;;
        -s )
            generate "screenshot"
            wait
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done

if [ ${#panels[@]} -gt 0 ]
{
    for panel in ${panels[@]}
    do
        generate_panel $panel $joinery
    done
    wait
}