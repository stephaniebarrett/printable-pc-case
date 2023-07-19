include <externals/honeycomb/honeycomb.scad>;
include <global.scad>
use <mainboard.scad>
use <fan.scad>
use <hdd.scad>
use <psu.scad>


draw_left_front(3,400,80,25);
draw_center_front(3,400,80,25);
draw_right_front(3,400,80,25);

draw_left_rear(3,400);
draw_center_rear(3,400);
draw_right_rear(3,400);

module draw_left_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        intersection()
        {
            translate([(rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5)-200,200,0]) cube(200);
            union()
            {
                draw_rack_floor(rackUnits,depth);
                draw_rack_walls(rackUnits,depth);
                draw_rack_rear(rackUnits, depth);
            }
        }
        // cutouts for the tabs
        for (i = [0 : 3])
        {
            x = rack_outer_dims[0] / 3 - RACK_TAB_SIZE[0] + 0.5 - EPSILON;
            y = depth - RACK_WALL_THICKNESS - ((i + .5) * RACK_TAB_SIZE[1]) * 2;
            translate([x,y,-EPSILON]) cube(RACK_TAB_SIZE);
            translate([x+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        }
    }
}

module draw_center_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        union()
        {
            intersection()
            {
                translate([rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,200,0]) cube([rack_outer_dims[0]/3,200,200]);
                union()
                {
                    draw_rack_floor(rackUnits,depth);
                    draw_rack_walls(rackUnits,depth);
                    draw_rack_rear(rackUnits, depth);
                }
            }
            // tabs on each side
            for (i = [0 : 3])
            {
                x = rack_outer_dims[0] / 3 - RACK_TAB_SIZE[0] + 0.5 - EPSILON;
                y = depth - RACK_WALL_THICKNESS - ((i + 0.5) * RACK_TAB_SIZE[1]) * 2;
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+1.5,y+0.5,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5,y+0.5,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        // left side tab holes
        for (i = [0 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - (i * RACK_TAB_SIZE[1]) * 2 - RACK_TAB_SIZE[1]/2;
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
        }
        
        // right side tab holes
        for (i = [0 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - (i * RACK_TAB_SIZE[1]) * 2 - RACK_TAB_SIZE[1]/2;
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
        }
    }
}

module draw_right_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        intersection()
        {
            translate([rack_outer_dims[0]/3*2+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,200,0]) cube(200);
            union()
            {
                draw_rack_floor(rackUnits,depth);
                draw_rack_walls(rackUnits,depth);
                draw_rack_rear(rackUnits, depth);
            }
        }
        // cutouts for the tabs
        for (i = [0 : 3])
        {
            x = rack_outer_dims[0] - rack_outer_dims[0] / 3 + 0.5 - EPSILON;
            y = depth - RACK_WALL_THICKNESS - ((i + .5) * RACK_TAB_SIZE[1]) * 2;
            translate([x,y,-EPSILON]) cube(RACK_TAB_SIZE);
            translate([x+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        }
    }
}

module draw_left_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        intersection()
        {
            translate([(rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5)-200,0,0]) cube(200);
            union()
            {
                draw_rack_floor(rackUnits,depth);
                draw_rack_walls(rackUnits,depth);
                draw_rack_front(rackUnits,depth,fanSize,fanDepth);
                draw_rack_ears(rackUnits,depth);
            }
        }
        // cutouts for the tabs
        for (y = [RACK_WALL_THICKNESS : RACK_TAB_SIZE[1]*2 : 200-RACK_TAB_SIZE[1]*2-1])
        {
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+.5+EPSILON,y,-EPSILON]) cube(RACK_TAB_SIZE);
        }
        // through holes for securing tabs together
        for (y = [RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 : RACK_TAB_SIZE[1]*2 : 200-RACK_TAB_SIZE[1]*2-1])
        {
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        }
    }
}

module draw_center_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        union()
        {
            intersection()
            {
                translate([rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,0,0]) cube([rack_outer_dims[0]/3,200,200]);
                union()
                {
                    draw_rack_floor(rackUnits,depth);
                    draw_rack_walls(rackUnits,depth);
                    draw_rack_front(rackUnits,depth,fanSize,fanDepth);
                    draw_rack_ears(rackUnits,depth);
                }
            }
            // tabs on each side
            for (y = [RACK_WALL_THICKNESS : RACK_TAB_SIZE[1]*2 : 200-1])
            {
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+1.5,y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5,y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        
        // left side tab holes
        for (y = [RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 : RACK_TAB_SIZE[1]*2 : 200-1])
        {
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
        }
        
        // right side tab holes
        for (y = [RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 : RACK_TAB_SIZE[1]*2 : 200-1])
        {
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=0.1);
        }

    }
}

module draw_right_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        intersection()
        {
            translate([rack_outer_dims[0]/3*2+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,0,0]) cube(200);
            union()
            {
                draw_rack_floor(rackUnits,depth);
                draw_rack_walls(rackUnits,depth);
                draw_rack_front(rackUnits,depth,fanSize,fanDepth);
                draw_rack_ears(rackUnits,depth);
            }
        }
        // cutouts for the tabs
        for (y = [RACK_WALL_THICKNESS : RACK_TAB_SIZE[1]*2 : 200-RACK_TAB_SIZE[1]*2-1])
        {
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5-EPSILON,y,-EPSILON]) cube(RACK_TAB_SIZE);
        }
        // through holes for securing tabs together
        for (y = [RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 : RACK_TAB_SIZE[1]*2 : 200-RACK_TAB_SIZE[1]*2-1])
        {
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, $fn=32);
        }

    }
}

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
            translate([0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2-mountingRailThickness(MOUNTING_SCREW_TYPE), rack_inner_dims[2]]);
            translate([0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
        }
        
        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]]) nutcatch_sidecut("M3");
    }

    // right wall
    difference()
    {
        union()
        {
            translate([rack_outer_dims[0]-RACK_WALL_THICKNESS-0,RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2-mountingRailThickness(MOUNTING_SCREW_TYPE), rack_inner_dims[2]]);
            translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
        }
    
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]]) rotate([0,0,180]) nutcatch_sidecut("M3");
    }
}

module draw_rack_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);
    
    translate([RACK_WALL_THICKNESS, 0, RACK_FLOOR_THICKNESS]) difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    // front pannel
                    translate([-RACK_WALL_THICKNESS,0,0]) cube([rack_outer_dims[0], RACK_WALL_THICKNESS, rack_height-RACK_FLOOR_THICKNESS]);
                    //mounting rails
                    translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
                    translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
                    translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
                    translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
                }
                
                // mounting rail holes
                offset = (rack_inner_dims[2]-fanSize)/2;
                for (z = [offset,rack_inner_dims[2]-offset])
                {
                    
                    // left side
                    translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5,RACK_WALL_THICKNESS+M3x10HeadDia,z]) union()
                    {
                        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=0.1);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=0.1, h=M3x10HeadHeight, hcld=0.4, $fn=32);
                    }
                    // right side
                    translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5,RACK_WALL_THICKNESS+M3x10HeadDia,z]) union()
                    {
                        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=0.1);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=0.1, h=M3x10HeadHeight, hcld=0.4, $fn=32);
                    }
                }
                
                // mounting rail roof holes
                translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");
                translate([rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");

                translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=0.1, $fn=32);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3");


                // fan through holes
                for (i = [0 : 2])
                {
                    x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
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
            x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
            z = (rack_height - fanSize) / 2 - RACK_FLOOR_THICKNESS;
            translate([x,0,z]) draw_fan_mounting_holes(fanSize, fanDepth, $fn=32);
        }
    }
}

module draw_rack_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);

    difference()
    {
        translate([0, rack_outer_dims[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) cube([rack_outer_dims[0], RACK_WALL_THICKNESS, rack_inner_dims[2]]);
        translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
        translate([PSU_POSITION[0], PSU_POSITION[1]+1, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
    }
    
    // left wall
    translate([0, depth-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS, 0]) difference()
    {
        translate([0,0,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
        
        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)/2,mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)/2,mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]]) nutcatch_sidecut("M3");
    }

    // right wall
    translate([0, depth-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS, 0]) difference()
    {
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE),0,RACK_FLOOR_THICKNESS]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
        
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,mountingRailThickness(MOUNTING_SCREW_TYPE)/2,RACK_FLOOR_THICKNESS+rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=0.1, $fn=32);
    
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]]) rotate([0,0,180]) nutcatch_sidecut("M3");
    }
}

module draw_rack_ears(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    for (i = [0 : rackUnits - 1])
    {
        z = i * RACK_EAR_SIZE[2];
        translate([-RACK_EAR_SIZE[0],0,z]) draw_rack_ear();
        translate([rack_outer_dims[0],0,z]) draw_rack_ear();
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
