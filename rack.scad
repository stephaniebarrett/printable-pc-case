include <externals/nutsnbolts/cyl_head_bolt.scad>;
//use <externals/nutsnbolts/data-access.scad>;
include <externals/honeycomb/honeycomb.scad>;

include <utility.scad>
use <fan.scad>

RACK_EAR_SIZE = [15.875, 6, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;
RACK_WALL_THICKNESS = 6;
RACK_FLOOR_THICKNESS = 10;
RACK_ROOF_THICKNESS = 6;
RACK_WIDTH = 450.85;

function get_rack_height(rackUnits=1) = (rackUnits * 44.5);
function get_rack_outer_dims(rackUnits, depth) = [RACK_WIDTH, depth, get_rack_height(rackUnits)];
function get_rack_inner_dims(rackUnits, depth) = [RACK_WIDTH - RACK_WALL_THICKNESS * 2, depth, get_rack_height(rackUnits) - RACK_FLOOR_THICKNESS - RACK_ROOF_THICKNESS];
function get_rack_wall_thickness() = RACK_WALL_THICKNESS;
function get_rack_floor_thickness() = RACK_FLOOR_THICKNESS;
function get_rack_roof_thickness() = RACK_ROOF_THICKNESS;

function mountingRailThickness(screwType) = _get_head_dia(screwType)*2;

TAB_SIZE = [30+EPSILON, 20+EPSILON, RACK_FLOOR_THICKNESS/2+EPSILON];
TAB_SIZE_SMALL = [30-.5, 20-1, RACK_FLOOR_THICKNESS/2-.5];

M3x10HeadHeight=_get_head_height("M3x10");
M3x10NutHeight =_get_nut_height("M3x10");
M3x10HeadDia=_get_head_dia("M3x10");

difference()
{
    draw_left_front(3,400,80,25);
    for (y = [RACK_WALL_THICKNESS : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH/3-TAB_SIZE[0]+.5,y,-EPSILON]) cube(TAB_SIZE);
    }
    for (y = [RACK_WALL_THICKNESS+TAB_SIZE[1]/2 : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH/3-TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
    }
}

difference()
{
    union()
    {
        draw_center_front(3,400,80,25);
        for (y = [RACK_WALL_THICKNESS : TAB_SIZE[1]*2 : 200-1])
        {
            translate([RACK_WIDTH/3-TAB_SIZE[0]+1.5,y+.5,0]) cube(TAB_SIZE_SMALL);
            translate([RACK_WIDTH-RACK_WIDTH/3+.5,y+.5,0]) cube(TAB_SIZE_SMALL);
        }
    }
    
    // left side
    for (y = [RACK_WALL_THICKNESS+TAB_SIZE[1]/2 : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH/3-TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        translate([RACK_WIDTH/3-TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
    }
    
    // right side
    for (y = [RACK_WALL_THICKNESS+TAB_SIZE[1]/2 : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH-RACK_WIDTH/3+TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        translate([RACK_WIDTH-RACK_WIDTH/3+TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
    }
}

difference()
{
    draw_right_front(3,400,80,25);
    for (y = [RACK_WALL_THICKNESS : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH-RACK_WIDTH/3+.5,y,-EPSILON]) cube(TAB_SIZE);
    }
    for (y = [RACK_WALL_THICKNESS+TAB_SIZE[1]/2 : TAB_SIZE[1]*2 : 200-1])
    {
        translate([RACK_WIDTH-RACK_WIDTH/3+TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
    }
}

/*
draw_rack_floor(3,400);
draw_rack_walls(3,400);
draw_rack_front(3,400,80,25);
draw_rack_ears(3);
*/

module draw_rack_floor(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);

    cube([rack_outer_dims[0], rack_outer_dims[1], RACK_FLOOR_THICKNESS]);
}

module draw_rack_walls(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);
    
    // left wall
    difference()
    {
        union()
        {
            translate([0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2, rack_inner_dims[2]]);
            translate([0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
        }
        
        translate([mountingRailThickness("M3x10")/2,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([mountingRailThickness("M3x10")/2,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]]) nutcatch_sidecut("M3");
    }

    // right wall
    difference()
    {
        union()
        {
            translate([rack_outer_dims[0]-RACK_WALL_THICKNESS-0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2, rack_inner_dims[2]]);
            translate([RACK_WIDTH-mountingRailThickness("M3x10"),RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
        }
    
        translate([RACK_WIDTH-mountingRailThickness("M3x10")/2,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([RACK_WIDTH-mountingRailThickness("M3x10")/2,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]]) rotate([0,0,180]) nutcatch_sidecut("M3");
    }
}

module draw_left_front(rackUnits, depth, fanSize, fanDepth)
{
    intersection()
    {
        translate([(RACK_WIDTH/3+RACK_WALL_THICKNESS-mountingRailThickness("M3x10")*0.5)-200,0,0]) cube(200);
        union()
        {
            draw_rack_floor(rackUnits,depth);
            draw_rack_walls(rackUnits,depth);
            draw_rack_front(rackUnits,depth,fanSize,fanDepth);
            draw_rack_ears(rackUnits);
        }
    }
}

module draw_center_front(rackUnits, depth, fanSize, fanDepth)
{
    intersection()
    {
        translate([RACK_WIDTH/3+RACK_WALL_THICKNESS-mountingRailThickness("M3x10")*0.5,0,0]) cube([RACK_WIDTH/3,200,200]);
        union()
        {
            draw_rack_floor(rackUnits,depth);
            draw_rack_walls(rackUnits,depth);
            draw_rack_front(rackUnits,depth,fanSize,fanDepth);
            draw_rack_ears(rackUnits);
        }
    }
}

module draw_right_front(rackUnits, depth, fanSize, fanDepth)
{
    intersection()
    {
        translate([RACK_WIDTH/3*2+RACK_WALL_THICKNESS-mountingRailThickness("M3x10")*0.5,0,0]) cube(200);
        union()
        {
            draw_rack_floor(rackUnits,depth);
            draw_rack_walls(rackUnits,depth);
            draw_rack_front(rackUnits,depth,fanSize,fanDepth);
            draw_rack_ears(rackUnits);
        }
    }
}

module draw_rack_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);

    M3x10HeadHeight=_get_head_height("M3x10");
    M3x10NutHeight =_get_nut_height("M3x10");
    M3x10HeadDia=_get_head_dia("M3x10");
    
    translate([RACK_WALL_THICKNESS, 0, RACK_FLOOR_THICKNESS]) difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    // front pannel
                    translate([-RACK_WALL_THICKNESS,0,0]) cube([RACK_WIDTH, RACK_WALL_THICKNESS, rack_height-RACK_FLOOR_THICKNESS]);
                    //mounting rails
                    translate([RACK_WIDTH/3-mountingRailThickness("M3x10")*1.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
                    translate([RACK_WIDTH/3-mountingRailThickness("M3x10")*0.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
                    translate([RACK_WIDTH-RACK_WIDTH/3-mountingRailThickness("M3x10")*1.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
                    translate([RACK_WIDTH-RACK_WIDTH/3-mountingRailThickness("M3x10")*0.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness("M3x10"),mountingRailThickness("M3x10"),rack_inner_dims[2]]);
                }
                
                // mounting rail holes
                offset = (rack_inner_dims[2]-fanSize)/2;
                for (z = [offset,rack_inner_dims[2]-offset])
                {
                    
                    // left side
                    translate([RACK_WIDTH/3-mountingRailThickness("M3x10")*1.5,RACK_WALL_THICKNESS+M3x10HeadDia,z]) union()
                    {
                        translate([mountingRailThickness("M3x10")*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=0.1);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness("M3x10")*2, cld=0.1, h=M3x10HeadHeight, hcld=0.4, $fn=32);
                    }
                    // right side
                    translate([RACK_WIDTH-RACK_WIDTH/3-mountingRailThickness("M3x10")*1.5,RACK_WALL_THICKNESS+M3x10HeadDia,z]) union()
                    {
                        translate([mountingRailThickness("M3x10")*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=0.1);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness("M3x10")*2, cld=0.1, h=M3x10HeadHeight, hcld=0.4, $fn=32);
                    }
                }
                
                // mounting rail roof holes
                translate([RACK_WIDTH/3-mountingRailThickness("M3x10"),RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([RACK_WIDTH/3-mountingRailThickness("M3x10"),RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");
                translate([RACK_WIDTH/3,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([RACK_WIDTH/3,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");

                translate([RACK_WIDTH-RACK_WIDTH/3-mountingRailThickness("M3x10"),RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([RACK_WIDTH-RACK_WIDTH/3-mountingRailThickness("M3x10"),RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");
                translate([RACK_WIDTH-RACK_WIDTH/3,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([RACK_WIDTH-RACK_WIDTH/3,RACK_WALL_THICKNESS+mountingRailThickness("M3x10")/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");


                // fan through holes
                for (i = [0 : 2])
                {
                    x = (RACK_WIDTH / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
                    z = (rack_height - fanSize) / 2 - RACK_FLOOR_THICKNESS;
                    translate([x,0,z]) draw_fan_through_hole(fanSize, fanSize, fanDepth, $fn=32);
                }

            }
            // honeycomb fill
            translate([0, RACK_WALL_THICKNESS, 0]) rotate([90,0,0]) linear_extrude(RACK_WALL_THICKNESS) honeycomb(rack_inner_dims[0], rack_inner_dims[2], 10, 2);
        }
        // fan mounting holes
        for (i = [0 : 2])
        {
            x = (RACK_WIDTH / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
            z = (rack_height - fanSize) / 2 - RACK_FLOOR_THICKNESS;
            translate([x,0,z]) draw_fan_mounting_holes(fanSize, fanDepth, $fn=32);
        }
    }
}

module draw_rack_ears(rackUnits)
{
    for (i = [0 : rackUnits - 1])
    {
        z = i * RACK_EAR_SIZE[2];
        translate([-RACK_EAR_SIZE[0],0,z]) draw_rack_ear();
        translate([RACK_WIDTH,0,z]) draw_rack_ear();
    }
}

module draw_rack_ear()
{
    //TODO: support circular holes
    difference()
    {
        cube(RACK_EAR_SIZE);
        for (i = [0 : 2])
        {
            z = i * RACK_EAR_HOLE_SPACING + RACK_EAR_HOLE_OFFSET;
            translate([RACK_EAR_SIZE[0]/2, RACK_EAR_SIZE[1]/2, z]) cube(9.4, center=true);
        }
    }
}
