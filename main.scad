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
#translate(MB_POSITION) draw_mATX_mainboard();

// DRAW PSU
#translate(PSU_POSITION) draw_ATX_psu();


// DRAW HDDs
for (i = [0 : 3])
{
    x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - COMPONENT_GAP;
    y = RACK_WALL_THICKNESS + 50;
    z = ((i + 1) * COMPONENT_GAP/2) + (i * HDD_35_DIMS[2]+RACK_FLOOR_THICKNESS);
    #translate([x, y, z]) rotate([0,0,90]) color(c=[.5,0,0,.5]) draw_hdd_35();
}

// DRAW FRONT FANS
for (i = [0 : 2])
{
    x = (RACK_OUTER_DIMS[0] / 3) * (i + .5) - FAN_SIZE / 2;
    z = (RACK_OUTER_DIMS[2] - FAN_SIZE) / 2;
    #translate([x, RACK_WALL_THICKNESS, z]) draw_fan(FAN_SIZE, FAN_SIZE, FAN_DEPTH);
}

// DRAW REAR FANS
fanSize = 40;

x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X - mATX_xOFFSET + MB_IO_CUTOUT_DIMS[0]/2 - fanSize/2;
y = RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS - FAN_DEPTH;
z = PSU_POSITION[2] + ATX_PSU_DIMS[2] - fanSize;

for (i = [-1:1])
{
    #translate([x+((fanSize+20)*i), y, z]) draw_fan(fanSize,fanSize,FAN_DEPTH);
}



// DRAW RACK ENCLOSURE
draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);
draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);
draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE,FAN_DEPTH);

draw_left_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_center_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_right_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
