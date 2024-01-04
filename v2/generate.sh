#!/bin/bash

# Script to export OpenSCAD files into .stl and .png
# Copyright (C) 2023 Stephanie Barrett (https://github.com/stephaniebarrett)
# Last revised 04/01/2024

# Usage: generate.sh [--[front|left|right|floor|roof|back|joinery|all]
#
# Options:
#   echo "  --front    Export the front panel."
#   echo "  --left     Export the left panel."
#   echo "  --right    Export the right panel."
#   echo "  --floor    Export the floor/bottom panel."
#   echo "  --roof     Export the roof/top panel."
#   echo "  --back     Export the rear/back."
#   echo "  --joinery  Export all the joinery; some object separation will be required in your slicer since multiple objects will be generated."
#   echo "  --all      All of the above."

openscad="/usr/bin/openscad"
input="main.scad"
output="export"

usage()
{
    echo
    echo "Usage: generate.sh [--[front|left|right|floor|roof|back|joinery|all]"
    echo "  --front    Export the front panel."
    echo "  --left     Export the left panel."
    echo "  --right    Export the right panel."
    echo "  --floor    Export the floor/bottom panel."
    echo "  --roof     Export the roof/top panel."
    echo "  --back     Export the rear/back."
    echo "  --joinery  Export all the joinery; some object separation will be required in your slicer since multiple objects will be generated."
    echo "  --all      All of the above."
    echo
    exit 1
}

generate()
{
    for i in 1 2 3
    do
        mkdir $output'/'$1
        stl=$output'/'$1'/'$1'-'$i'.stl'
        png=$output'/'$1'/'$1'-'$i'.png'

        echo "Rendering ${input} into ${stl} and ${png}."

        openscad -o $stl -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D JOINERY=$8 -D SECTION=$i -D EXPLODED=0 $input &
        openscad -o $png -D FRONT=$2 -D LEFT=$3 -D RIGHT=$4 -D FLOOR=$5 -D ROOF=$6 -D BACK=$7 -D JOINERY=$8 -D SECTION=$i -D EXPLODED=0 --autocenter --viewall --imgsize 1024,1024 $input &
    done
}

generate_all()
{
    generate "front" 1 0 0 0 0 0 0
    generate "left" 0 1 0 0 0 0 0
    generate "right" 0 0 1 0 0 0 0
    generate "floor" 0 0 0 1 0 0 0
    generate "roof" 0 0 0 0 1 0 0
    generate "back" 0 0 0 0 0 1 0
    generate "joinery" 1 1 1 1 1 1 1
}

while [ $# -gt 0 ]
do
    case $1 in
        --front) generate "front" 1 0 0 0 0 0 0;;
        --left) generate "left" 0 1 0 0 0 0 0;;
        --right) generate "right" 0 0 1 0 0 0 0;;
        --floor | --bottom) generate "floor" 0 0 0 1 0 0 0;;
        --roof | --top) generate "roof" 0 0 0 0 1 0 0;;
        --back | --rear) generate "back" 0 0 0 0 0 1 0;;
        --joinery) generate "joinery" 1 1 1 1 1 1 1;;
        --all) generate_all;;
        *) usage;;
    esac
    shift
done
wait