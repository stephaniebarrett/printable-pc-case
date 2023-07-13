// 3rd Party
include <Text/alpha.scad>
include <honeycomb.scad>

// Helpers
include <utility.scad>

// PC Components
include <mainboard.scad>
include <psu.scad>
include <hdd.scad>
include <fan.scad>

// Case Components
include <rack.scad>

USE_LABELS = false;
COMPONENT_GAP = 5;
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
translate(MB_POSITION) draw_mATX_mainboard(USE_LABELS);

// DRAW PSU
translate(PSU_POSITION) draw_ATX_psu(USE_LABELS);

// DRAW HDDs
for (i = [0 : 4])
{
    x = rack_outer_dims[0] - get_rack_wall_thickness() - COMPONENT_GAP;
    y = get_rack_wall_thickness() + 50;
    z = ((i + 1) * COMPONENT_GAP) + (i * hdd_dims[2]);
    translate([x, y, z]) rotate([0,0,90]) draw_hdd_35(USE_LABELS);
}

// DRAW RACK EARS
for (i = [0 : NUMBER_OF_RACK_UNITS - 1])
{
    z = i * RACK_EAR_SIZE[2];
    translate([-RACK_EAR_SIZE[0],0,z]) draw_rack_ear();
    translate([rack_outer_dims[0],0,z]) draw_rack_ear();
}

fanSize = 80;
fanDepth = 25;

// DRAW FRONT FANS
for (i = [0 : 2])
{
    x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2;
    z = (rack_outer_dims[2] - fanSize) / 2;
    translate([x, get_rack_wall_thickness(), z]) draw_fan(fanSize, fanSize, fanDepth);
}

// DRAW RACK ENCLOSURE
draw_rack_enclosure(NUMBER_OF_RACK_UNITS, RACK_DEPTH);

// DRAW RACK FRONT PANEL
translate([get_rack_wall_thickness(), 0, get_rack_floor_thickness()]) difference()
{
    union()
    {
        difference()
        {
            cube([rack_inner_dims[0], get_rack_wall_thickness(), rack_inner_dims[2]]);
            for (i = [0 : 2])
            {
                x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - get_rack_wall_thickness();
                z = (rack_outer_dims[2] - fanSize) / 2 - get_rack_floor_thickness();
                translate([x,0,z]) draw_fan_through_hole(fanSize, fanSize, fanDepth);
            }

        }
        translate([0, get_rack_wall_thickness(), 0]) rotate([90,0,0]) linear_extrude(get_rack_wall_thickness()) honeycomb(rack_inner_dims[0], rack_inner_dims[2], 10, 2);
    }
    for (i = [0 : 2])
    {
        x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - get_rack_wall_thickness();
        z = (rack_outer_dims[2] - fanSize) / 2 - get_rack_floor_thickness();
        translate([x,0,z]) draw_fan_mounting_holes(fanSize, fanDepth);
    }
}

// DRAW REAR PANEL
difference()
{
    translate([get_rack_wall_thickness(), RACK_DEPTH - get_rack_wall_thickness(), get_rack_floor_thickness()]) cube([rack_inner_dims[0], get_rack_wall_thickness(), rack_inner_dims[2]]);
    translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
    translate([PSU_POSITION[0], PSU_POSITION[1]+1, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
}
