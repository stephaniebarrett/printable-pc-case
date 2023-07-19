// 3rd Party
include <externals/alpha/alpha.scad>
//include <externals/honeycomb/honeycomb.scad>

// Helpers
include <utility.scad>

// PC Components
include <mainboard.scad>
include <psu.scad>
include <hdd.scad>
use <fan.scad>

// Case Components
include <rack.scad>

USE_LABELS = false;
COMPONENT_GAP = 6;
NUMBER_OF_RACK_UNITS = 3;
RACK_DEPTH = 400;
MB_STANDOFF_SIZE = [5.5, 5.5, 6];
mATX_mb_dims = get_mATX_mainboard_dims();
ATX_psu_dims = get_ATX_psu_dims();
hdd_dims = get_hdd_dims();
rack_outer_dims = get_rack_outer_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);
rack_inner_dims = get_rack_inner_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);

MB_POSITION = [get_rack_wall_thickness() + COMPONENT_GAP, rack_outer_dims[1] - mATX_mb_dims[1] - get_rack_wall_thickness(), get_rack_floor_thickness() + MB_STANDOFF_SIZE[2]];
PSU_POSITION = [rack_outer_dims[0] - ATX_psu_dims[0] - get_rack_wall_thickness() - COMPONENT_GAP, rack_outer_dims[1] - ATX_psu_dims[1] - get_rack_wall_thickness(), get_rack_floor_thickness()];

// DRAW MAINBOARD
translate(MB_POSITION) color(c=[.5,0,0,.5]) draw_mATX_mainboard(USE_LABELS);

// DRAW PSU
translate(PSU_POSITION) color(c=[.5,0,0,.5]) draw_ATX_psu(USE_LABELS);

// DRAW HDDs
for (i = [0 : 4])
{
    x = rack_outer_dims[0] - get_rack_wall_thickness() - COMPONENT_GAP;
    y = get_rack_wall_thickness() + 50;
    z = ((i + 1) * COMPONENT_GAP) + (i * hdd_dims[2]);
    translate([x, y, z]) rotate([0,0,90]) color(c=[.5,0,0,.5]) draw_hdd_35(USE_LABELS);
}

fanSize = 80;
fanDepth = 25;

// DRAW FRONT FANS
for (i = [0 : 2])
{
    x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2;
    z = (rack_outer_dims[2] - fanSize) / 2;
    translate([x, get_rack_wall_thickness(), z]) color(c=[.5,0,0,.5]) draw_fan(fanSize, fanSize, fanDepth);
}

// NOTE: Most of the rack is currently being drawn from within rack.scad
// DRAW RACK ENCLOSURE
//#draw_rack_enclosure(NUMBER_OF_RACK_UNITS, RACK_DEPTH);
//draw_rack_floor(NUMBER_OF_RACK_UNITS, RACK_DEPTH);
//draw_rack_front(NUMBER_OF_RACK_UNITS, RACK_DEPTH, fanSize, fanDepth);
//draw_rack_ears(NUMBER_OF_RACK_UNITS);

// DRAW REAR PANEL
difference()
{
    translate([get_rack_wall_thickness(), RACK_DEPTH - get_rack_wall_thickness(), get_rack_floor_thickness()]) cube([rack_inner_dims[0], get_rack_wall_thickness(), rack_inner_dims[2]]);
    translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
    translate([PSU_POSITION[0], PSU_POSITION[1]+1, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
}

