// Helpers
include <global.scad>

// PC Components
use <mainboard.scad>
use <psu.scad>
use <hdd.scad>
use <fan.scad>

// Case Components
use <rack.scad>


// DRAW MAINBOARD
translate(MB_POSITION) color(c=[.5,0,0,.5]) draw_mATX_mainboard();

// DRAW PSU
translate(PSU_POSITION) color(c=[.5,0,0,.5]) draw_ATX_psu();

// DRAW HDDs
for (i = [0 : 4])
{
    x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - COMPONENT_GAP;
    y = RACK_WALL_THICKNESS + 50;
    z = ((i + 1) * COMPONENT_GAP) + (i * HDD_35_DIMS[2]);
    translate([x, y, z]) rotate([0,0,90]) color(c=[.5,0,0,.5]) draw_hdd_35();
}

// DRAW FRONT FANS
for (i = [0 : 2])
{
    x = (RACK_OUTER_DIMS[0] / 3) * (i + .5) - FAN_SIZE / 2;
    z = (RACK_OUTER_DIMS[2] - FAN_SIZE) / 2;
    translate([x, RACK_WALL_THICKNESS, z]) color(c=[.5,0,0,.5]) draw_fan(FAN_SIZE, FAN_SIZE, FAN_DEPTH);
}

// DRAW RACK ENCLOSURE
draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);
draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);
draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);

// DRAW REAR PANEL
difference()
{
    translate([RACK_WALL_THICKNESS, RACK_DEPTH - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) cube([RACK_INNER_DIMS[0], RACK_WALL_THICKNESS, RACK_INNER_DIMS[2]]);
    translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
    translate([PSU_POSITION[0], PSU_POSITION[1]+1, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
}

