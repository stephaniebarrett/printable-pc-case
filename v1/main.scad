// Helpers
include <global.scad>

// Case Components
include <rack.scad>

DRAW_RACK = 0;
DRAW_JOINERY = 0;
DRAW_HDD_CAGE = 0;

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
else if (DRAW_HDD_CAGE == 5)
{
    cageX = RACK_WALL_THICKNESS + HDD_X_OFFSET;
    cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
    translate([cageX, cageY, RACK_FLOOR_THICKNESS]) draw_hdd_cage_vertical("hdd", 3);
}
else
{
    draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
    draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
    draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
    draw_left_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
    draw_center_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
    draw_right_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
}