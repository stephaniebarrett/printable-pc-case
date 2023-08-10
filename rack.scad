//include <externals/honeycomb/honeycomb.scad>;
include <global.scad>
use <mainboard.scad>
use <fan.scad>
use <hdd.scad>
use <psu.scad>

// DRAW MAINBOARD GHOST
#translate(MB_POSITION) color(c=[.5,0,0,.5]) draw_mATX_mainboard();

// DRAW PSU GHOST
#translate(PSU_POSITION) color(c=[.5,0,0,.5]) draw_ATX_psu();

// DRAW 3.5 HDD CAGE GHOST

cageX = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET;
cageY = RACK_WALL_THICKNESS + HDD_Y_OFFSET;

difference()
{
    #translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_35_cage_riser();

    // make space for through holes that secure the rack secions together
    union()
    {
        for (i = [1 : 3])
        {
            y = RACK_WALL_THICKNESS + RACK_TAB_SIZE[1] / 2 + (RACK_TAB_SIZE[1] * 2) * i;
            translate([RACK_OUTER_DIMS[0]-RACK_OUTER_DIMS[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+HDD_CAGE_SHELF_DIMS[2]+EPSILON]) hole_through(name="M4",h=HDD_CAGE_SHELF_DIMS[2]+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
        }
    }
}
#translate([cageX, cageY, RACK_FLOOR_THICKNESS]) rotate([0,0,90]) draw_hdd_35_cage_riserWithRails();


draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);

draw_left_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_center_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_right_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);

draw_left_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_center_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_right_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);

module draw_left_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([(rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5)-200,100,0]) cube(200);
        draw_horizontal_joinery(rackUnits, depth);
    }
}

module draw_center_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,100,0]) cube([rack_outer_dims[0]/3,200,200]);
        draw_horizontal_joinery(rackUnits, depth);
    }
}

module draw_right_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([rack_outer_dims[0]/3*2+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5,100,0]) cube(200);
        draw_horizontal_joinery(rackUnits, depth);
    }
}

module draw_left_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    difference()
    {
        intersection()
        {
            translate([(rack_outer_dims[0]/3+RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)*0.5)-200,200,0]) cube(200);
            draw_rack(rackUnits, depth);
        }
        // cutouts for the tabs
        for (i = [1 : 3])
        {
            x = rack_outer_dims[0] / 3 - RACK_TAB_SIZE[0] + 0.5 - EPSILON;
            y = depth - RACK_WALL_THICKNESS - ((i + .5) * RACK_TAB_SIZE[1]) * 2;
            translate([x,y,-EPSILON]) cube(RACK_TAB_SIZE);
            translate([x+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
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
            for (i = [1 : 3])
            {
                x = rack_outer_dims[0] / 3 - RACK_TAB_SIZE[0] + 0.5 - EPSILON;
                y = depth - RACK_WALL_THICKNESS - ((i + 0.5) * RACK_TAB_SIZE[1]) * 2;
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+1.5,y+0.5,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5,y+0.5,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        draw_PSU_floor_vent();
        // left side tab holes
        for (i = [1 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - (i * RACK_TAB_SIZE[1]) * 2 - RACK_TAB_SIZE[1]/2;
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
        }
        
        // right side tab holes
        for (i = [1 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - (i * RACK_TAB_SIZE[1]) * 2 - RACK_TAB_SIZE[1]/2;
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
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
            draw_rack(rackUnits, depth);
        }
        // cutouts for the tabs
        for (i = [1 : 3])
        {
            x = rack_outer_dims[0] - rack_outer_dims[0] / 3 + 0.5 - EPSILON;
            y = depth - RACK_WALL_THICKNESS - ((i + .5) * RACK_TAB_SIZE[1]) * 2;
            translate([x,y,-EPSILON]) cube(RACK_TAB_SIZE);
            translate([x+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
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
                draw_rack(rackUnits, depth, fanSize, fanDepth);
                draw_rack_ears(rackUnits, depth);
            }
        }
        for (i = [1 : 3])
        {
            y = RACK_WALL_THICKNESS + i * (RACK_TAB_SIZE[1]*2);
            // cutouts for the tabs
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+.5+EPSILON,y,-EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
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
                draw_rack(rackUnits, depth, fanSize, fanDepth);
            }
            // tabs on each side
            for (y = [RACK_WALL_THICKNESS : RACK_TAB_SIZE[1]*2 : 200-1])
            {
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+1.5,y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5,y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        
        // left side tab holes
        for (i = [1 : 3])
        {
            y = RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 + i * RACK_TAB_SIZE[1]*2;
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
        }
        
        // right side tab holes
        for (i = [1 : 3])
        {
            y = RACK_WALL_THICKNESS+RACK_TAB_SIZE[1]/2 + i * RACK_TAB_SIZE[1]*2;
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
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
                draw_rack(rackUnits, depth, fanSize, fanDepth);
                draw_rack_ears(rackUnits, depth);
            }
        }
        for (i = [1 : 3])
        {
            y = RACK_WALL_THICKNESS + i * (RACK_TAB_SIZE[1]*2);
            // cutouts for the tabs
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+.5-EPSILON,y,-EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
        }
        // through holes to mount 3.5 HDD cage
        y = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
        for (i = [0 : 1])
        {
            x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET - HDD_35_SIDE_MOUNT_HOLES[i][1];
            translate([x, y + HDD_CAGE_PILLAR_DIMS[1] / 2, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, hcld=THhcld, $fn=32);
            translate([x, y + HDD_CAGE_SHELF_DIMS[0] + (HDD_CAGE_PILLAR_DIMS[1]*1.5), -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
        }

    }
}

module draw_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);

    tabX = RACK_TAB_SIZE[1];
    tabY = RACK_TAB_SIZE[0]*2;
    
    x = rack_outer_dims[0]/2;
    y = rack_outer_dims[1]/2;

    difference()
    {
        union()
        {
            translate([x,y,(RACK_FLOOR_THICKNESS-0.5)/4]) cube([tabX*6-1,tabX-1,(RACK_FLOOR_THICKNESS-0.5)/2], center=true);
            translate([x-tabX*7-1,y,(RACK_FLOOR_THICKNESS-0.5)/4]) cube([tabX*3-1,tabX-1,(RACK_FLOOR_THICKNESS-0.5)/2], center=true);
            translate([x+tabX*7+1,y,(RACK_FLOOR_THICKNESS-0.5)/4]) cube([tabX*3-1,tabX-1,(RACK_FLOOR_THICKNESS-0.5)/2], center=true);
            // center cutout
            translate([x,y,(RACK_FLOOR_THICKNESS-0.5)/4]) cube([tabX-1,tabY-1,(RACK_FLOOR_THICKNESS-0.5)/2],center=true);
            // the rest of the cutouts
            for (i = [2:2:6])
            {
                for (j = [-tabX*i*1.5, tabX*i*1.5])
                {
                    // cutouts
                    translate([x+j,y,(RACK_FLOOR_THICKNESS-0.5)/4]) cube([tabX-1,tabY-1,(RACK_FLOOR_THICKNESS-0.5)/2],center=true);
                }
            }
        }
        
        // screw holes
        for (i = [0:2:6])
        {
            for (j = [-tabX*i*1.5, tabX*i*1.5])
            {
                for (k = [-tabY/3,tabY/3])
                {   
                    translate([x+j,y+k,RACK_FLOOR_THICKNESS]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
                    translate([x+j,y+k,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
                }
            }
        }
    }
}


module draw_PSU_floor_vent()
{
    translate([PSU_POSITION[0]+ATX_PSU_DIMS[0]/2-40,PSU_POSITION[1]+ATX_PSU_DIMS[1]/2-40,RACK_FLOOR_THICKNESS]) rotate([-90,0,0]) draw_fan_through_hole(80, 80, RACK_FLOOR_THICKNESS*2);
}


module draw_rack_floor(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);

    tabX = RACK_TAB_SIZE[1];
    tabY = RACK_TAB_SIZE[0]*2;
    
    difference()
    {
        x = rack_outer_dims[0]/2;
        y = rack_outer_dims[1]/2;

        // floor
        cube([x*2, y*2, RACK_FLOOR_THICKNESS]);
        draw_PSU_floor_vent();
        
        translate([x,y,0]) cube([tabX*19,tabX,RACK_FLOOR_THICKNESS], center=true);
        // the rest of the cutouts
        for (i = [0:2:8])
        {
            for (j = [-tabX*i*1.5, tabX*i*1.5])
            {
                // cutouts
                translate([x+j,y,0]) cube([tabX,tabY,RACK_FLOOR_THICKNESS],center=true);
                for (k = [-tabY/3,tabY/3])
                {   
                    // screw holes
                    translate([x+j,y+k,RACK_FLOOR_THICKNESS]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
                }
            }
        }
        
    }
    // PSU support rails
    translate([PSU_POSITION[0]+RACK_WALL_THICKNESS,PSU_POSITION[1],PSU_POSITION[2]-RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, ATX_PSU_DIMS[1], RACK_FLOOR_THICKNESS]);
    translate([PSU_POSITION[0]+ATX_PSU_DIMS[0]-RACK_WALL_THICKNESS*2,PSU_POSITION[1],PSU_POSITION[2]-RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, ATX_PSU_DIMS[1], RACK_FLOOR_THICKNESS]);
    // MB standoffs
    translate([MB_POSITION[0], MB_POSITION[1], MB_POSITION[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_standoffs(mATX_MB_DIMS, mATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, mATX_xOFFSET);
}

module draw_rack_walls(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    draw_rack_right_wall(rackUnits, depth);
    translate([rack_outer_dims[0], rack_outer_dims[1], 0]) rotate([0,0,180]) draw_rack_right_wall(rackUnits, depth);
}

module draw_rack_left_wall(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    translate([rack_outer_dims[0], rack_outer_dims[1], 0]) rotate([0,0,180]) draw_rack_right_wall(rackUnits, depth);
}

//TODO: much of this module can be simplified with loops and a little cleaner math
module draw_rack_right_wall(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);

    difference()
    {
        translate([rack_outer_dims[0], 0, RACK_FLOOR_THICKNESS]) union()
        {
            //wall
            translate([-RACK_WALL_THICKNESS,RACK_WALL_THICKNESS,0]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2-mountingRailThickness(MOUNTING_SCREW_TYPE), rack_inner_dims[2]]);
            
            //near mount
            translate([-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
            
            //near-mid mount
            translate([-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-mountingRailThickness(MOUNTING_SCREW_TYPE),0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);

            //far-mid mount
            translate([-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS,rack_outer_dims[1]/2,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);

            //far mount
            translate([-mountingRailThickness(MOUNTING_SCREW_TYPE),rack_outer_dims[1]-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS,0]) cube([mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]]);
                
        }
    
        // roof mounting holes
        translate([rack_outer_dims[0]-mountingRailThickness(MOUNTING_SCREW_TYPE)/2, RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2, rack_inner_dims[2]]) union()
        {
            // near mount
            translate([0,0,0]) union() 
            {
                translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
            }

            // near-mid mount
            translate([-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-mountingRailThickness(MOUNTING_SCREW_TYPE)-RACK_WALL_THICKNESS,0]) union() 
            {
                translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
            }

            // far-mid mount
            translate([-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-RACK_WALL_THICKNESS,0]) union() 
            {
                translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
            }
        
            // far mount
            translate([0,rack_outer_dims[1]-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5-RACK_WALL_THICKNESS,0]) union() 
            {
                translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
            }
        }
        
        // module mounting holes
        for (z = [RACK_FLOOR_THICKNESS*3, rack_outer_dims[2]-RACK_FLOOR_THICKNESS*3])
        {
            translate([rack_outer_dims[0]-RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_outer_dims[1]/2-mountingRailThickness(MOUNTING_SCREW_TYPE),z]) rotate([90,0,0]) union()
            {
                translate([0,0,-mountingRailThickness(MOUNTING_SCREW_TYPE)*2+M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh);
                hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
            }
        }

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
                        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=NPclh);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
                    }
                    // right side
                    translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*1.5,RACK_WALL_THICKNESS+M3x10HeadDia,z]) union()
                    {
                        translate([mountingRailThickness(MOUNTING_SCREW_TYPE)*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=NPclh);
                        rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
                    }
                }
                
                // mounting rail roof holes
                translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=THcld, hcld=THhcld, $fn=32);
                translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                translate([rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=THcld, hcld=THhcld, $fn=32);
                translate([rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);

                translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=THcld, hcld=THhcld, $fn=32);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE),RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offset/2, cld=THcld, hcld=THhcld, $fn=32);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,RACK_WALL_THICKNESS+mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_inner_dims[2]-offset/2]) rotate([0,0,90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);


                if (fanSize > 0)
                {
                    // fan through holes
                    for (i = [0 : 2])
                    {
                        x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
                        z = (rack_height - fanSize) / 2 - RACK_FLOOR_THICKNESS;
                        translate([x,0,z]) draw_fan_through_hole(fanSize, fanSize, fanDepth);
                    }
                }

            }
            // honeycomb fill
            //translate([0, RACK_WALL_THICKNESS, 0]) rotate([90,0,0]) linear_extrude(RACK_WALL_THICKNESS) honeycomb(rack_inner_dims[0], rack_inner_dims[2], 10, 2);
        }
        
        if (fanSize > 0)
        {
            // fan mounting holes
            for (i = [0 : 2])
            {
                x = (rack_outer_dims[0] / 3) * (i + .5) - fanSize / 2 - RACK_WALL_THICKNESS;
                z = (rack_height - fanSize) / 2 - RACK_FLOOR_THICKNESS;
                translate([x,0,z]) draw_fan_mounting_holes(fanSize, fanDepth);
            }
        }
    }
}

//TODO: provide structure for PCI cards
module draw_rack_rear(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);

    mountSize = [mountingRailThickness(MOUNTING_SCREW_TYPE),mountingRailThickness(MOUNTING_SCREW_TYPE),rack_inner_dims[2]-ATX_PSU_DIMS[2]-RACK_FLOOR_THICKNESS-1];
    //module mounting points
   
    difference()
    {
        translate([RACK_WALL_THICKNESS,0,RACK_FLOOR_THICKNESS]) union()
        {
            z = rack_inner_dims[2]-mountSize[2];
            y = rack_outer_dims[1]-RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE);
            translate([rack_outer_dims[0]/2-mountingRailThickness(MOUNTING_SCREW_TYPE),y,z]) cube(mountSize);
            for (i = [1.5, 0.5])
            {
                translate([rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*i,y,z]) cube(mountSize);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)*i,y,z]) cube(mountSize);
            }
        }
        
        // module mounting holes
        for (x = [rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)+0.5, rack_outer_dims[0]-rack_outer_dims[0]/3-mountingRailThickness(MOUNTING_SCREW_TYPE)+0.5])
        {
            translate([x,rack_outer_dims[1]-RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)+mountSize[1]/2,rack_inner_dims[2]]) union()
            {
                translate([mountSize[0]*2-M3x10NutHeight-0.1,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=NPclh);
                rotate([0,-90,0]) hole_through(name="M3", l=mountingRailThickness(MOUNTING_SCREW_TYPE)*2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
            }
        }
        // roof mounting holes
        translate([rack_outer_dims[0]/2+0.5,rack_outer_dims[1]-RACK_WALL_THICKNESS-mountingRailThickness(MOUNTING_SCREW_TYPE)/2,rack_outer_dims[2]-RACK_WALL_THICKNESS]) union()
        {
            translate([0,0,EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
            translate([0,0,-RACK_WALL_THICKNESS]) rotate([0,0,-90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
        }

    }

    difference()
    {
        translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
        //wall
        translate([0, rack_outer_dims[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) cube([rack_outer_dims[0], RACK_WALL_THICKNESS, rack_inner_dims[2]]);
        //io cutout
        translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X-mATX_xOFFSET, rack_outer_dims[1]-RACK_WALL_THICKNESS-EPSILON, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z]) cube([MB_IO_CUTOUT_DIMS[0],MB_IO_CUTOUT_DIMS[1]+1,MB_IO_CUTOUT_DIMS[2]]);
        //io inset
        translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X-mATX_xOFFSET-MB_IO_CUTOUT_BORDER/2, rack_outer_dims[1]-RACK_WALL_THICKNESS*2+1, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z-MB_IO_CUTOUT_BORDER/2]) cube([MB_IO_CUTOUT_DIMS[0]+MB_IO_CUTOUT_BORDER,RACK_WALL_THICKNESS,MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER]);
        //psu mounting holes
        translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
        // flipped psu mounting holes
        translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,180,0]) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
        //psu wall vent
        translate([PSU_POSITION[0]+10, PSU_POSITION[1]+ATX_PSU_DIMS[1]-EPSILON, PSU_POSITION[2]+10]) cube([ATX_PSU_DIMS[0]-20,RACK_WALL_THICKNESS+EPSILON*2,ATX_PSU_DIMS[2]-20]);
        //rear fans
        // DRAW REAR FANS
        fanSize = 40;

        x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X - mATX_xOFFSET + MB_IO_CUTOUT_DIMS[0]/2 - fanSize/2;
        y = RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS - FAN_DEPTH/2;
        z = PSU_POSITION[2] + ATX_PSU_DIMS[2] - fanSize;

        for (i = [-1:1])
        {
            translate([x+((fanSize+20)*i), y, z]) draw_fan_through_hole(fanSize,fanSize,FAN_DEPTH);
            translate([x+((fanSize+20)*i), y, z]) draw_fan_mounting_holes(fanSize,FAN_DEPTH);
        }

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

module draw_rack(rackUnits, depth, fanSize=0, fanDepth=0)
{
    union()
    {
        draw_rack_floor(rackUnits, depth);
        draw_rack_walls(rackUnits, depth);
        draw_rack_rear(rackUnits, depth);
        draw_rack_front(rackUnits, depth, fanSize, fanDepth);

    }
}