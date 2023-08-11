// Helpers
include <global.scad>

// PC Components
use <mainboard.scad>
use <psu.scad>
use <hdd.scad>
use <fan.scad>

// Case Components
use <rack.scad>

DRAW_GHOSTS = false;
DRAW_RACK = 0;
DRAW_JOINERY = 0;
DRAW_HDD_CAGE = 0;

if (DRAW_GHOSTS)
{
    // DRAW GHOST MAINBOARD
    #translate(MB_POSITION) draw_mATX_mainboard();
    // DRAW GHOST PSU
    #translate(PSU_POSITION) draw_ATX_psu();
    // DRAW GHOST FRONT FANS
    frontFanPosZ = (RACK_OUTER_DIMS[2] - FAN_SIZE_FRONT) / 2;
    for (i = [0:2])
    {
        frontFanPosX = (RACK_OUTER_DIMS[0] / 3) * (i + .5) - FAN_SIZE_FRONT / 2;
        #translate([frontFanPosX, RACK_WALL_THICKNESS, frontFanPosZ]) draw_fan(FAN_SIZE_FRONT, FAN_SIZE_FRONT, FAN_DEPTH);
    }
    // DRAW GHOST REAR FANS
    rearFanPosX = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X - mATX_xOFFSET + MB_IO_CUTOUT_DIMS[0]/2 - FAN_SIZE_REAR/2;
    rearFanPosY = RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS - FAN_DEPTH;
    rearFanPosZ = PSU_POSITION[2] + ATX_PSU_DIMS[2] - FAN_SIZE_REAR;
    for (i = [-1:1])
    {
        #translate([rearFanPosX+((FAN_SIZE_REAR+20)*i), rearFanPosY, rearFanPosZ]) draw_fan(FAN_SIZE_REAR,FAN_SIZE_REAR,FAN_DEPTH);
    }
    // DRAW GHOST HDDs
    for (i = [0:3])
    {
        x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
        y = RACK_WALL_THICKNESS + HDD_CAGE_PILLAR_DIMS[1] + HDD_CAGE_BUFFER_X / 2 + HDD_Y_OFFSET;
        z = RACK_FLOOR_THICKNESS + i * HDD_35_CAGE_SHELF_SPACING + HDD_35_CAGE_SHELF_DIMS[2];
        #translate([x, y, z]) rotate([0,0,90]) draw_hdd_35();
    }
}



if (DRAW_RACK == 1)
    draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
else if (DRAW_RACK == 2)
    draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
else if (DRAW_RACK == 3)
    draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
else if (DRAW_RACK == 4)
    draw_left_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_RACK == 5)
    draw_center_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_RACK == 6)
    draw_right_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_JOINERY == 1)
    draw_left_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_JOINERY == 2)
    draw_center_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_JOINERY == 3)
    draw_right_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
else if (DRAW_HDD_CAGE == 1)
{
    cageX = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
    cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
    difference()
    {
        translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_cage("hdd",false);

        // make space for through holes that secure the rack secions together
        union()
        {
            for (i = [1 : 3])
            {
                y = RACK_WALL_THICKNESS + RACK_TAB_SIZE[1] / 2 + (RACK_TAB_SIZE[1] * 2) * i;
                translate([RACK_OUTER_DIMS[0]-RACK_OUTER_DIMS[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+HDD_35_CAGE_SHELF_DIMS[2]+EPSILON]) hole_through(name="M4",h=HDD_35_CAGE_SHELF_DIMS[2]+EPSILON, $fn=32);
            }
        }
    }
}
else if (DRAW_HDD_CAGE == 2)
{
    cageX = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
    cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
    translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_cage("hdd",true);
}
else if (DRAW_HDD_CAGE == 3)
{
    cageX = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
    cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
    translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_cage("ssd",false);
}
else if (DRAW_HDD_CAGE == 4)
{
    cageX = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
    cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
    translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_cage("ssd",true);
}