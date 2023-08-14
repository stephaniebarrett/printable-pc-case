include <global.scad>
use <mainboard.scad>
use <fan.scad>
use <hdd.scad>
use <psu.scad>

// DRAW MAINBOARD GHOST
%translate(MB_POSITION)
if (CASE_CONFIGURATION == 1)
     draw_mATX_mainboard();
else if (CASE_CONFIGURATION == 2)
    draw_ATX_mainboard();

// DRAW PSU GHOST
%translate(PSU_POSITION) draw_ATX_psu();

ssdOffsetX = HDD_35_SIDE_MOUNT_HOLES[1][1]-HDD_25_SIDE_MOUNT_HOLES[1][1];
ssdOffsetY = get_hdd_cage_width("hdd") - get_hdd_cage_width("ssd");
rightCage = [RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET, RACK_WALL_THICKNESS + HDD_Y_OFFSET, RACK_FLOOR_THICKNESS];
leftCage = [RACK_WALL_THICKNESS + HDD_X_OFFSET, RACK_WALL_THICKNESS + HDD_Y_OFFSET + get_hdd_cage_width("hdd"), RACK_FLOOR_THICKNESS];

// DRAW 2.5 HDD CAGE GHOSTS
// right side
%translate([rightCage[0]-ssdOffsetX, rightCage[1], rightCage[2]]) rotate([0,0,90]) draw_hdd_cage("ssd", true);
%translate([rightCage[0]-ssdOffsetX, rightCage[1], rightCage[2]]) rotate([0,0,90]) draw_hdd_cage("ssd", false);
// left side
%translate([leftCage[0]+ssdOffsetX, leftCage[1] - ssdOffsetY, leftCage[2]]) rotate([0,0,-90]) draw_hdd_cage("ssd", true);
%translate([leftCage[0]+ssdOffsetX, leftCage[1] - ssdOffsetY, leftCage[2]]) rotate([0,0,-90]) draw_hdd_cage("ssd", false);

// DRAW 3.5 HDD CAGE GHOSTS
if (CASE_CONFIGURATION == 1)
{
    %difference()
    {
        union()
        {
            translate(rightCage) rotate([0,0,90]) draw_hdd_cage("hdd", true);
            translate(rightCage) rotate([0,0,90]) draw_hdd_cage("hdd", false);
        }

        // make space for through holes that secure the rack sections together
        union()
        {
            for (i = [1 : 3])
            {
                y = RACK_WALL_THICKNESS + RACK_TAB_SIZE[1] / 2 + (RACK_TAB_SIZE[1] * 2) * i;
                translate([RACK_OUTER_DIMS[0]-RACK_OUTER_DIMS[0]/3+RACK_TAB_SIZE[0]/2,y,RACK_FLOOR_THICKNESS+HDD_35_CAGE_SHELF_DIMS[2]+EPSILON]) hole_through(name="M4",h=HDD_35_CAGE_SHELF_DIMS[2]+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
            }
        }
    }
}
else if (CASE_CONFIGURATION == 2)
{
    %translate([RACK_WALL_THICKNESS + HDD_X_OFFSET, RACK_WALL_THICKNESS + HDD_Y_OFFSET, RACK_FLOOR_THICKNESS]) draw_hdd_cage_vertical("hdd", HDD_35_CAGE_NUM_DRIVES_CONFIG2);
}


draw_left_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
draw_center_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);
draw_right_front(NUMBER_OF_RACK_UNITS,RACK_DEPTH,FAN_SIZE_FRONT,FAN_DEPTH);

draw_left_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_center_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_right_rear(NUMBER_OF_RACK_UNITS,RACK_DEPTH);

draw_left_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_center_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);
draw_right_horizontal_joinery(NUMBER_OF_RACK_UNITS,RACK_DEPTH);


//draw_rack(NUMBER_OF_RACK_UNITS, RACK_DEPTH, FAN_SIZE_FRONT, FAN_DEPTH);

module draw_left_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([-RACK_EAR_SIZE[0],100,0]) cube([RACK_OUTER_DIMS[0]/3+RACK_EAR_SIZE[0],200,200]);
        draw_horizontal_joinery(rackUnits, depth);
    }
}

module draw_center_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([rack_outer_dims[0]/3,100,0]) cube([rack_outer_dims[0]/3,200,200]);
        draw_horizontal_joinery(rackUnits, depth);
    }
}

module draw_right_horizontal_joinery(rackUnits, depth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    intersection()
    {
        translate([rack_outer_dims[0]-rack_outer_dims[0]/3,100,0]) cube([rack_outer_dims[0]/3+RACK_EAR_SIZE[0],200,200]);
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
            translate([-RACK_EAR_SIZE[0],RACK_OUTER_DIMS[1]-200,0])  cube([RACK_OUTER_DIMS[0]/3+RACK_EAR_SIZE[0],200,200]);
            draw_rack(rackUnits, depth);
        }
        // cutouts for the tabs
        x = rack_outer_dims[0] / 3;
        for (i = [1 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - i * (RACK_TAB_SIZE[1] * 2);
            // cutouts for the tabs
            translate([x - RACK_TAB_SIZE[0], y, -EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([x - RACK_TAB_SIZE_SMALL[0] / 2, y + RACK_TAB_SIZE[1] / 2, RACK_FLOOR_THICKNESS + EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
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
                translate([rack_outer_dims[0]/3,depth-200,0]) cube([rack_outer_dims[0]/3,200,200]);
                union()
                {
                    draw_rack_floor(rackUnits,depth);
                    draw_rack_rear(rackUnits, depth);
                }
            }
            // tabs on each side
            for (i = [1 : 3])
            {
                y = depth - RACK_WALL_THICKNESS - i * (RACK_TAB_SIZE[1] * 2);
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE_SMALL[0],y+RACK_TAB_SIZE_DIFFERENCE[1]/2,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,y+RACK_TAB_SIZE_DIFFERENCE[1]/2,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        draw_PSU_floor_vent();
        // tab holes on each side
        for (x = [rack_outer_dims[0] / 3 - RACK_TAB_SIZE_SMALL[0] / 2,  rack_outer_dims[0] - rack_outer_dims[0] / 3 + RACK_TAB_SIZE[0] / 2])
        {
            for (i = [1 : 3])
            {
                y = depth - RACK_WALL_THICKNESS - i * (RACK_TAB_SIZE[1] * 2) + RACK_TAB_SIZE[1] / 2;
                translate([x,y,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
                translate([x,y,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
            }
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
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3,depth-200,0]) cube([rack_outer_dims[0]/3+RACK_EAR_SIZE[0],200,200]);
            draw_rack(rackUnits, depth);
        }
        // cutouts for the tabs
        x = rack_outer_dims[0] - rack_outer_dims[0] / 3;
        for (i = [1 : 3])
        {
            y = depth - RACK_WALL_THICKNESS - i * (RACK_TAB_SIZE[1] * 2);
            // cutouts for the tabs
            translate([x,y,-EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([x+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
        }
    }
}

module draw_left_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    ssdOffsetX = HDD_35_SIDE_MOUNT_HOLES[1][1]-HDD_25_SIDE_MOUNT_HOLES[1][1];
    ssdOffsetY = get_hdd_cage_width("hdd") - get_hdd_cage_width("ssd");
    rightCage = [RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET, RACK_WALL_THICKNESS + HDD_Y_OFFSET, RACK_FLOOR_THICKNESS];
    leftCage = [RACK_WALL_THICKNESS + HDD_X_OFFSET, RACK_WALL_THICKNESS + HDD_Y_OFFSET + get_hdd_cage_width("hdd"), RACK_FLOOR_THICKNESS];

    difference()
    {
        intersection()
        {
            translate([-RACK_EAR_SIZE[0],0,0]) cube([rack_outer_dims[0]/3+RACK_EAR_SIZE[0],200,200]);
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
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]+EPSILON,y,-EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([rack_outer_dims[0]/3-RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
        }
        // through holes to mount 2.5 HDD cage
        {
            y = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
            for (i = [0 : 1])
            {
                x = RACK_WALL_THICKNESS + HDD_X_OFFSET + HDD_25_SIDE_MOUNT_HOLES[i][1];
                translate([x+ssdOffsetX, y + HDD_CAGE_PILLAR_DIMS[1] / 2, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, hcld=THhcld, $fn=32);
                translate([x+ssdOffsetX, y + HDD_25_CAGE_SHELF_DIMS[0] + (HDD_CAGE_PILLAR_DIMS[1]*1.5), -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
            }
        }
        // through holes to mount 3.5 HDD cage
        if (CASE_CONFIGURATION == 2)
        {
            w = (HDD_35_DIMS[2] + HDD_35_CAGE_SHELF_DIMS[1] + HDD_CAGE_BUFFER_X/2) * HDD_35_CAGE_NUM_DRIVES_CONFIG2 + HDD_CAGE_BUFFER_X;
            x = RACK_WALL_THICKNESS + HDD_X_OFFSET + HDD_CAGE_PILLAR_DIMS[0]/2;
            for (i = [0 : 1])
            {
                y = HDD_35_SIDE_MOUNT_HOLES[i][1]+RACK_WALL_THICKNESS + HDD_Y_OFFSET;
                translate([x, y, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, hcld=THhcld, $fn=32);
                translate([x+w, y, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
            }
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
                translate([rack_outer_dims[0]/3,0,0]) cube([rack_outer_dims[0]/3,200,200]);
                draw_rack(rackUnits, depth, fanSize, fanDepth);
            }
            // tabs on each side
            for (i = [1 : 3])
            {
                y = RACK_WALL_THICKNESS + i * (RACK_TAB_SIZE[1] * 2);
                translate([rack_outer_dims[0]/3-RACK_TAB_SIZE_SMALL[0],y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
                translate([rack_outer_dims[0]-rack_outer_dims[0]/3,y+.5,0]) cube(RACK_TAB_SIZE_SMALL);
            }
        }
        // through holes
        for (x = [rack_outer_dims[0] / 3 - RACK_TAB_SIZE_SMALL[0] / 2, rack_outer_dims[0] - rack_outer_dims[0] / 3 + RACK_TAB_SIZE_SMALL[0] / 2])
        {
            for (i = [1 : 3])
            {
                y = RACK_WALL_THICKNESS + RACK_TAB_SIZE[1] / 2 + i * RACK_TAB_SIZE[1] * 2;
                translate([x, y, RACK_FLOOR_THICKNESS + EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
                translate([x, y, M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
            }
        }
    }
}

module draw_right_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    ssdCageOffset = HDD_35_SIDE_MOUNT_HOLES[1][1]-HDD_25_SIDE_MOUNT_HOLES[1][1];

    difference()
    {
        intersection()
        {
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3,0,0]) cube([rack_outer_dims[0]/3+RACK_EAR_SIZE[0],200,200]);
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
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3,y,-EPSILON]) cube(RACK_TAB_SIZE);
            // through holes for securing tabs together
            translate([rack_outer_dims[0]-rack_outer_dims[0]/3+RACK_TAB_SIZE[0]/2,y+RACK_TAB_SIZE[1]/2,RACK_FLOOR_THICKNESS+EPSILON]) hole_through(name="M3",h=M3x10HeadHeight, cld=THcld, hcld=THhcld, $fn=32);
        }
        // through holes to mount 3.5 HDD cage
        if (CASE_CONFIGURATION == 1)
        {
            y = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
            for (i = [0 : 1])
            {
                x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET - HDD_35_SIDE_MOUNT_HOLES[i][1];
                translate([x, y + HDD_CAGE_PILLAR_DIMS[1] / 2, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, hcld=THhcld, $fn=32);
                translate([x, y + HDD_35_CAGE_SHELF_DIMS[0] + (HDD_CAGE_PILLAR_DIMS[1]*1.5), -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
            }
        }
        // through holes to mount 2.5 HDD cage
        for (i = [0 : 1])
        {
            y = RACK_WALL_THICKNESS + HDD_Y_OFFSET;
            x = RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - HDD_X_OFFSET - HDD_25_SIDE_MOUNT_HOLES[i][1];
            translate([x-ssdCageOffset, y + HDD_CAGE_PILLAR_DIMS[1] / 2, -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, hcld=THhcld, $fn=32);
            translate([x-ssdCageOffset, y + HDD_25_CAGE_SHELF_DIMS[0] + (HDD_CAGE_PILLAR_DIMS[1]*1.5), -EPSILON]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
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
                    translate([x+j,y+k,M3x10NutHeight]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
                }
            }
        }
    }
}


module draw_PSU_floor_vent()
{
    translate(PSU_FLOOR_VENT_POSITION) rotate([-90,0,0]) draw_fan_through_hole(PSU_FLOOR_VENT_HOLE_SIZE, PSU_FLOOR_VENT_HOLE_SIZE, RACK_FLOOR_THICKNESS*2);
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

        // joinery cutouts
        translate([x,y,0]) cube([tabX*6,tabX,RACK_FLOOR_THICKNESS], center=true);
        translate([x-tabX*7,y,0]) cube([tabX*3,tabX,RACK_FLOOR_THICKNESS], center=true);
        translate([x+tabX*7,y,0]) cube([tabX*3,tabX,RACK_FLOOR_THICKNESS], center=true);

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

    draw_psu_supports();
    draw_mb_supports();
}

module draw_psu_supports()
{
    if (CASE_CONFIGURATION == 1)
    {
        // PSU support rails
        translate([PSU_POSITION[0]+RACK_WALL_THICKNESS,PSU_POSITION[1],PSU_POSITION[2]-RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, ATX_PSU_DIMS[1], RACK_FLOOR_THICKNESS]);
        translate([PSU_POSITION[0]+ATX_PSU_DIMS[0]-RACK_WALL_THICKNESS*2,PSU_POSITION[1],PSU_POSITION[2]-RACK_FLOOR_THICKNESS]) cube([RACK_WALL_THICKNESS, ATX_PSU_DIMS[1], RACK_FLOOR_THICKNESS]);
    }
    else if (CASE_CONFIGURATION == 2)
    {
        translate([RACK_MODULE_JOINING_PILLAR_DIMS[0], RACK_DEPTH-RACK_MODULE_JOINING_PILLAR_DIMS[1]/2-RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) difference()
        {
            cube([MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3, RACK_MODULE_JOINING_PILLAR_DIMS[1]/2, PSU_POSITION[2]-RACK_FLOOR_THICKNESS]);
            translate([2,-0.5,0]) cube([MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3-4, RACK_MODULE_JOINING_PILLAR_DIMS[1]/2+1, PSU_POSITION[2]-RACK_FLOOR_THICKNESS-2]);
        }
        translate([RACK_MODULE_JOINING_PILLAR_DIMS[0], RACK_DEPTH-RACK_WALL_THICKNESS+RACK_MODULE_JOINING_PILLAR_DIMS[1]/2, RACK_FLOOR_THICKNESS]) rotate([90,0,0]) linear_extrude(RACK_MODULE_JOINING_PILLAR_DIMS[1])
        {
            honeycomb(MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3, PSU_POSITION[2]-RACK_FLOOR_THICKNESS, HONEYCOMB_DIAMETER, HONEYCOMB_SIZE);
        }

        translate([RACK_WALL_THICKNESS,RACK_DEPTH-RACK_WALL_THICKNESS-ATX_PSU_DIMS[1]+RACK_MODULE_JOINING_PILLAR_DIMS[1]/2,RACK_FLOOR_THICKNESS])
        {
            difference()
            {
                cube([MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3, RACK_MODULE_JOINING_PILLAR_DIMS[1]/2, PSU_POSITION[2]-RACK_FLOOR_THICKNESS]);
                translate([2,-.5,0]) cube([MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3-4, RACK_MODULE_JOINING_PILLAR_DIMS[1]/2+1, PSU_POSITION[2]-RACK_FLOOR_THICKNESS-2]);
            }
            translate([-2,RACK_MODULE_JOINING_PILLAR_DIMS[1]/2,-2]) rotate([90,0,0]) linear_extrude(RACK_MODULE_JOINING_PILLAR_DIMS[1]/2)
            {
                honeycomb(MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3, PSU_POSITION[2]-RACK_FLOOR_THICKNESS,PSU_POSITION[2]-RACK_FLOOR_THICKNESS+4,2);
            }

        }
    }
}

module draw_mb_supports()
{
    // MB standoffs
    if (CASE_CONFIGURATION == 1)
        translate([MB_POSITION[0], MB_POSITION[1], MB_POSITION[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_standoffs(mATX_MB_DIMS, mATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, mATX_xOFFSET);
    if (CASE_CONFIGURATION == 2)
        translate([MB_POSITION[0], MB_POSITION[1], MB_POSITION[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_standoffs(ATX_MB_DIMS, ATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, 0);
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
            translate([-RACK_WALL_THICKNESS,RACK_WALL_THICKNESS,0]) cube([RACK_WALL_THICKNESS, depth-RACK_WALL_THICKNESS*2-RACK_MODULE_JOINING_PILLAR_DIMS[1], rack_inner_dims[2]]);
            
            //near mount
            translate([-RACK_MODULE_JOINING_PILLAR_DIMS[0],RACK_WALL_THICKNESS,0]) cube(RACK_MODULE_JOINING_PILLAR_DIMS);
            
            //near-mid mount
            translate([-RACK_MODULE_JOINING_PILLAR_DIMS[0]-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-RACK_MODULE_JOINING_PILLAR_DIMS[1],0]) cube(RACK_MODULE_JOINING_PILLAR_DIMS);

            //far-mid mount
            translate([-RACK_MODULE_JOINING_PILLAR_DIMS[0]-RACK_WALL_THICKNESS,rack_outer_dims[1]/2,0]) cube(RACK_MODULE_JOINING_PILLAR_DIMS);

            //far mount
            translate([-RACK_MODULE_JOINING_PILLAR_DIMS[0],rack_outer_dims[1]-RACK_MODULE_JOINING_PILLAR_DIMS[1]-RACK_WALL_THICKNESS,0]) cube(RACK_MODULE_JOINING_PILLAR_DIMS);
                
        }
    
        // roof mounting holes
        translate([rack_outer_dims[0]-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2, RACK_WALL_THICKNESS+RACK_MODULE_JOINING_PILLAR_DIMS[1]/2, rack_inner_dims[2]]) union()
        {
            // near mount
            translate([0,0,0]) union() 
            {
                if (USE_HEATSETS)
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=8, cld=THcld, hcld=THhcld, $fn=32);
                    translate([0,0,RACK_FLOOR_THICKNESS-M3HEATSET_HEIGHT+EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                }
                else
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                    rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                }
            }

            // near-mid mount
            translate([-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-RACK_MODULE_JOINING_PILLAR_DIMS[1]-RACK_WALL_THICKNESS,0]) union() 
            {
                if (USE_HEATSETS)
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=8, cld=THcld, hcld=THhcld, $fn=32);
                    translate([0,0,RACK_FLOOR_THICKNESS-M3HEATSET_HEIGHT+EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                }
                else
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                    rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                }
            }

            // far-mid mount
            translate([-RACK_WALL_THICKNESS,rack_outer_dims[1]/2-RACK_WALL_THICKNESS,0]) union() 
            {
                if (USE_HEATSETS)
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=8, cld=THcld, hcld=THhcld, $fn=32);
                    translate([0,0,RACK_FLOOR_THICKNESS-M3HEATSET_HEIGHT+EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                }
                else
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                    rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                }
            }
        
            // far mount
            translate([0,rack_outer_dims[1]-RACK_MODULE_JOINING_PILLAR_DIMS[1]*1.5-RACK_WALL_THICKNESS,0]) union() 
            {
                if (USE_HEATSETS)
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=8, cld=THcld, hcld=THhcld, $fn=32);
                    translate([0,0,RACK_FLOOR_THICKNESS-M3HEATSET_HEIGHT+EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                }
                else
                {
                    translate([0,0,RACK_FLOOR_THICKNESS+EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                    rotate([0,0,180]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                }
            }
        }
        
        // module mounting holes
        for (z = [RACK_FLOOR_THICKNESS*3, rack_outer_dims[2]-RACK_FLOOR_THICKNESS*3])
        {
            translate([rack_outer_dims[0]-RACK_WALL_THICKNESS-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2,rack_outer_dims[1]/2-RACK_MODULE_JOINING_PILLAR_DIMS[1],z]) rotate([90,0,0]) union()
            {
                translate([0,0,-RACK_MODULE_JOINING_PILLAR_DIMS[0]*2-M3x10HeadHeight]) rotate([0,0,90]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
                hole_through(name="M3", l=RACK_MODULE_JOINING_PILLAR_DIMS[0]*2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
            }
        }

    }
}

//TODO: add support for front panel I/O
module draw_rack_front(rackUnits, depth, fanSize, fanDepth)
{
    rack_outer_dims = get_rack_outer_dims(rackUnits, depth);
    rack_inner_dims = get_rack_inner_dims(rackUnits, depth);
    rack_height = get_rack_height(rackUnits);

    translate([0, 0, RACK_FLOOR_THICKNESS]) difference()
    {
        // basic structure
        union()
        {
            // front panel
            cube([rack_outer_dims[0], RACK_WALL_THICKNESS, rack_inner_dims[2] + RACK_WALL_THICKNESS]);

            // mounting pillars
            for (x = [rack_outer_dims[0] / 3 - RACK_MODULE_JOINING_PILLAR_DIMS[0], rack_outer_dims[0] - rack_outer_dims[0] / 3 - RACK_MODULE_JOINING_PILLAR_DIMS[0]])
            {
                difference()
                {
                    offsetZ = (rack_inner_dims[2] - fanSize) / 2;
                    // pillar
                    translate([x, RACK_WALL_THICKNESS, 0]) cube([RACK_MODULE_JOINING_PILLAR_DIMS[0] * 2, RACK_MODULE_JOINING_PILLAR_DIMS[1], RACK_MODULE_JOINING_PILLAR_DIMS[2]]);
                    if (USE_HEATSETS)
                    {
                        translate([x + RACK_MODULE_JOINING_PILLAR_DIMS[0] / 2, RACK_WALL_THICKNESS + RACK_MODULE_JOINING_PILLAR_DIMS[1] / 2, rack_inner_dims[2] + EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=8, cld=THcld, hcld=THhcld, $fn=32);
                        translate([x + RACK_MODULE_JOINING_PILLAR_DIMS[0] / 2, RACK_WALL_THICKNESS + RACK_MODULE_JOINING_PILLAR_DIMS[1] / 2, rack_inner_dims[2] - M3HEATSET_HEIGHT + EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                    }
                    else
                    {
                        // roof bolt hole in the pillar
                        translate([x + RACK_MODULE_JOINING_PILLAR_DIMS[0] / 2, RACK_WALL_THICKNESS + RACK_MODULE_JOINING_PILLAR_DIMS[1] / 2, rack_inner_dims[2] + EPSILON]) rotate([0,0,90]) hole_through(name="M3", l=offsetZ/2, cld=THcld, hcld=THhcld, $fn=32);
                        // roof captive nut cutout in the pillar
                        translate([x + RACK_MODULE_JOINING_PILLAR_DIMS[0] / 2, RACK_WALL_THICKNESS + RACK_MODULE_JOINING_PILLAR_DIMS[1] / 2, rack_inner_dims[2] - offsetZ / 2]) rotate([0,0,90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                    }
                    // horizontal fasteners
                    for (z = [offsetZ, rack_inner_dims[2] - offsetZ])
                    {
                        // bolt side
                        translate([x, RACK_WALL_THICKNESS + M3x10HeadDia, z]) rotate([0,-90,0]) hole_through(name="M3", l=RACK_MODULE_JOINING_PILLAR_DIMS[0] * 2, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
                        // nut side
                        translate([x + RACK_MODULE_JOINING_PILLAR_DIMS[0] * 2 - M3x10NutHeight, RACK_WALL_THICKNESS + M3x10HeadDia, z]) rotate([0, -90, 0]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
                    }
                }
            }
        }

        // fan through holes
        if (fanSize > 0)
        {
            z = rack_outer_dims[2] / 2 - fanSize / 2 - RACK_FLOOR_THICKNESS;
            for (i = [0 : 2])
            {
                x = (rack_outer_dims[0] / 3) * i + fanSize / 2 - RACK_WALL_THICKNESS;
                translate([x,0,z]) union()
                {
                    draw_fan_through_hole(fanSize, fanSize, fanDepth);
                    draw_fan_mounting_holes(fanSize, fanDepth);
                }
            }
        }
    }

    // honeycomb
    if (fanSize > 0)
    {
        intersection()
        {
            translate([0,RACK_WALL_THICKNESS,0]) rotate([90,0,0]) linear_extrude(RACK_WALL_THICKNESS)
            {
                honeycomb(RACK_OUTER_DIMS[0], RACK_OUTER_DIMS[2], HONEYCOMB_DIAMETER, HONEYCOMB_SIZE);
            }
            z = rack_outer_dims[2] / 2 - fanSize / 2;
            for (i = [0 : 2])
            {
                x = (rack_outer_dims[0] / 3) * i + fanSize / 2 - RACK_WALL_THICKNESS;
                translate([x,0,z]) union()
                {
                    draw_fan_through_hole(fanSize, fanSize, fanDepth);
                }
            }
        }
    }
}

//TODO: provide structure for PCI cards
module draw_rack_rear(rackUnits, depth)
{
    mountSize = [RACK_MODULE_JOINING_PILLAR_DIMS[0],RACK_MODULE_JOINING_PILLAR_DIMS[1],RACK_MODULE_JOINING_PILLAR_DIMS[1]];

    if (CASE_CONFIGURATION == 1)
    {
        //module mounting points
        difference()
        {
            translate([0,0,RACK_FLOOR_THICKNESS]) union()
            {
                z = RACK_INNER_DIMS[2]-mountSize[2];
                y = RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-RACK_MODULE_JOINING_PILLAR_DIMS[1];
                difference()
                {
                    translate([RACK_OUTER_DIMS[0]/2-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2,y,z]) cube(mountSize);
                    // roof mounting holes
                    translate([RACK_OUTER_DIMS[0]/2-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2+RACK_MODULE_JOINING_PILLAR_DIMS[0]/2,y+RACK_MODULE_JOINING_PILLAR_DIMS[1]/2,RACK_INNER_DIMS[2] + EPSILON]) union()
                    {
                        rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                        if (USE_HEATSETS)
                        {
                            translate([0, 0, -M3HEATSET_HEIGHT]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                        }
                        else
                        {
                            translate([0,0,-RACK_FLOOR_THICKNESS]) rotate([0,0,-90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                        }
                    }
                }
                for (i = [0, 1])
                {
                    x = RACK_OUTER_DIMS[0] / 3 - RACK_MODULE_JOINING_PILLAR_DIMS[0] * i;
                    translate([x, y, z]) cube(mountSize);
                    translate([RACK_OUTER_DIMS[0] - x - RACK_MODULE_JOINING_PILLAR_DIMS[0], y, z]) cube(mountSize);
                }
            }
            
            // module mounting holes
            for (x = [RACK_OUTER_DIMS[0]/3-RACK_MODULE_JOINING_PILLAR_DIMS[0], RACK_OUTER_DIMS[0]-RACK_OUTER_DIMS[0]/3-RACK_MODULE_JOINING_PILLAR_DIMS[0]])
            {
                translate([x,RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-RACK_MODULE_JOINING_PILLAR_DIMS[1]+mountSize[1]/2,RACK_OUTER_DIMS[2]-mountSize[2]]) union()
                {
                    translate([mountSize[0]*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
                    rotate([0,-90,0]) hole_through(name="M3", l=RACK_MODULE_JOINING_PILLAR_DIMS[0]*2-M3x10HeadHeight, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
                }
            }
        }

        difference()
        {
            translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
            //wall
            translate([0, RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) cube([RACK_OUTER_DIMS[0], RACK_WALL_THICKNESS, RACK_INNER_DIMS[2]]);
            //io cutout
            translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X-mATX_xOFFSET, RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-EPSILON, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z]) cube([MB_IO_CUTOUT_DIMS[0],MB_IO_CUTOUT_DIMS[1]+1,MB_IO_CUTOUT_DIMS[2]]);
            //io inset
            translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X-mATX_xOFFSET-MB_IO_CUTOUT_BORDER/2, RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS*2+1, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z-MB_IO_CUTOUT_BORDER/2]) cube([MB_IO_CUTOUT_DIMS[0]+MB_IO_CUTOUT_BORDER,RACK_WALL_THICKNESS,MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER]);
            //psu mounting holes
            translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
            // flipped psu mounting holes
            translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,180,0]) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
            //psu wall vent
            translate([PSU_POSITION[0]+10, PSU_POSITION[1]+ATX_PSU_DIMS[1]-EPSILON, PSU_POSITION[2]+10]) cube([ATX_PSU_DIMS[0]-20,RACK_WALL_THICKNESS+EPSILON*2,ATX_PSU_DIMS[2]-20]);
            //rear fans
            // DRAW REAR FANS
            x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X - mATX_xOFFSET + MB_IO_CUTOUT_DIMS[0]/2 - FAN_SIZE_REAR/2;
            y = RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS - FAN_DEPTH/2;
            z = PSU_POSITION[2] + ATX_PSU_DIMS[2] - FAN_SIZE_REAR;

            for (i = [-1:1])
            {
                translate([x+(2*i)+((FAN_SIZE_REAR+20)*i), y, z]) draw_fan_through_hole(FAN_SIZE_REAR,FAN_SIZE_REAR,FAN_DEPTH);
                translate([x+(2*i)+((FAN_SIZE_REAR+20)*i), y, z]) draw_fan_mounting_holes(FAN_SIZE_REAR,FAN_DEPTH);
            }
        }
        // honeycomb
        {
            x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X  - mATX_xOFFSET + MB_IO_CUTOUT_DIMS[0]/2 - FAN_SIZE_REAR/2;
            y = RACK_OUTER_DIMS[1];
            z = PSU_POSITION[2] + ATX_PSU_DIMS[2] - FAN_SIZE_REAR;

            for (i = [-1:1])
            {
                intersection()
                {
                    translate([x+(2*i)+((FAN_SIZE_REAR+20)*i),y,z]) rotate([90,0,0]) linear_extrude(RACK_WALL_THICKNESS)
                    {
                        honeycomb(FAN_SIZE_REAR, FAN_SIZE_REAR, HONEYCOMB_DIAMETER, HONEYCOMB_SIZE);
                    }
                    translate([x+(2*i)+((FAN_SIZE_REAR+20)*i), y - RACK_WALL_THICKNESS - FAN_DEPTH/2, z]) draw_fan_through_hole(FAN_SIZE_REAR,FAN_SIZE_REAR,FAN_DEPTH);
                }
            }
        }
    }
    else if (CASE_CONFIGURATION == 2)
    {
        difference()
        {
            translate([0,0,RACK_FLOOR_THICKNESS]) union()
            {
                z = RACK_INNER_DIMS[2]-mountSize[2];
                y = RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-RACK_MODULE_JOINING_PILLAR_DIMS[1];
                difference()
                {
                    translate([RACK_OUTER_DIMS[0]/2-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2,y,z]) cube(mountSize);
                    // roof mounting holes
                    translate([RACK_OUTER_DIMS[0]/2-RACK_MODULE_JOINING_PILLAR_DIMS[0]/2+RACK_MODULE_JOINING_PILLAR_DIMS[0]/2,y+RACK_MODULE_JOINING_PILLAR_DIMS[1]/2,RACK_INNER_DIMS[2] + EPSILON]) union()
                    {
                        rotate([0,0,90]) hole_through(name="M3", l=RACK_FLOOR_THICKNESS, cld=THcld, hcld=THhcld, $fn=32);
                        if (USE_HEATSETS)
                        {
                            translate([0, 0, -M3HEATSET_HEIGHT]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                        }
                        else
                        {
                            translate([0,0,-RACK_FLOOR_THICKNESS]) rotate([0,0,-90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                        }
                    }
                }
                for (i = [0, 1])
                {
                    x = RACK_OUTER_DIMS[0] / 3 - RACK_MODULE_JOINING_PILLAR_DIMS[0] * i;
                    translate([RACK_OUTER_DIMS[0] - x - RACK_MODULE_JOINING_PILLAR_DIMS[0], y, z]) cube(mountSize);
                }
            }
            
            // module mounting holes
            for (x = [RACK_OUTER_DIMS[0]/3-RACK_MODULE_JOINING_PILLAR_DIMS[0], RACK_OUTER_DIMS[0]-RACK_OUTER_DIMS[0]/3-RACK_MODULE_JOINING_PILLAR_DIMS[0]])
            {
                translate([x,RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-RACK_MODULE_JOINING_PILLAR_DIMS[1]+mountSize[1]/2,RACK_OUTER_DIMS[2]-mountSize[2]]) union()
                {
                    translate([mountSize[0]*2-M3x10NutHeight,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3", clh=NPclh, clk=NPclk);
                    rotate([0,-90,0]) hole_through(name="M3", l=RACK_MODULE_JOINING_PILLAR_DIMS[0]*2-M3x10HeadHeight, cld=THcld, h=M3x10HeadHeight, hcld=THhcld, $fn=32);
                }
            }
        }

        difference()
        {
            translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
            //wall
            translate([0, RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS]) cube([RACK_OUTER_DIMS[0], RACK_WALL_THICKNESS, RACK_INNER_DIMS[2]]);
            //io cutout
            translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X, RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS-EPSILON, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z]) cube([MB_IO_CUTOUT_DIMS[0],MB_IO_CUTOUT_DIMS[1]+1,MB_IO_CUTOUT_DIMS[2]]);
            //io inset
            translate([MB_POSITION[0]+MB_IO_CUTOUT_OFFSET_X-MB_IO_CUTOUT_BORDER/2, RACK_OUTER_DIMS[1]-RACK_WALL_THICKNESS*2+1, MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z-MB_IO_CUTOUT_BORDER/2]) cube([MB_IO_CUTOUT_DIMS[0]+MB_IO_CUTOUT_BORDER,RACK_WALL_THICKNESS,MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER]);
            //psu mounting holes
            translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
            // flipped psu mounting holes
            translate([PSU_POSITION[0], PSU_POSITION[1]+RACK_WALL_THICKNESS, PSU_POSITION[2]]) translate(-translateToCenter) rotate([0,180,0]) rotate([0,0,180]) translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
            //psu wall vents
            translate([PSU_POSITION[0]+10, PSU_POSITION[1]+ATX_PSU_DIMS[1]-EPSILON, PSU_POSITION[2]+10]) cube([ATX_PSU_DIMS[0]-20,RACK_WALL_THICKNESS+EPSILON*2,ATX_PSU_DIMS[2]-20]);
            translate([RACK_MODULE_JOINING_PILLAR_DIMS[0]+2,RACK_DEPTH-RACK_WALL_THICKNESS-0.5,RACK_FLOOR_THICKNESS]) cube([MB_POSITION[0]-RACK_WALL_THICKNESS-COMPONENT_GAP/3-4, RACK_MODULE_JOINING_PILLAR_DIMS[1]/2+2, PSU_POSITION[2]-RACK_FLOOR_THICKNESS-2]);
            //rear fans
            // DRAW REAR FANS
            x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X + MB_IO_CUTOUT_DIMS[0]/2 - FAN_SIZE_REAR/2;
            y = RACK_OUTER_DIMS[1] - RACK_WALL_THICKNESS - FAN_DEPTH/2;
            z = MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z+MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER+5;

            for (i = [-1:1])
            {
                translate([x+(2*i)+((FAN_SIZE_REAR+10)*i), y, z]) draw_fan_through_hole(FAN_SIZE_REAR,FAN_SIZE_REAR,FAN_DEPTH);
                translate([x+(2*i)+((FAN_SIZE_REAR+10)*i), y, z]) draw_fan_mounting_holes(FAN_SIZE_REAR,FAN_DEPTH);
            }
        }
        // honeycomb
        {
            x = MB_POSITION[0] + MB_IO_CUTOUT_OFFSET_X + MB_IO_CUTOUT_DIMS[0]/2 - FAN_SIZE_REAR/2;
            y = RACK_OUTER_DIMS[1];
            z = MB_POSITION[2]+MB_IO_CUTOUT_OFFSET_Z+MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER+5;

            for (i = [-1:1])
            {
                intersection()
                {
                    translate([x+(2*i)+((FAN_SIZE_REAR+10)*i),y,z]) rotate([90,0,0]) linear_extrude(RACK_WALL_THICKNESS)
                    {
                        honeycomb(FAN_SIZE_REAR, FAN_SIZE_REAR, HONEYCOMB_DIAMETER, HONEYCOMB_SIZE);
                    }
                    translate([x+(2*i)+((FAN_SIZE_REAR+10)*i), y - RACK_WALL_THICKNESS - FAN_DEPTH/2, z]) draw_fan_through_hole(FAN_SIZE_REAR,FAN_SIZE_REAR,FAN_DEPTH);
                }
            }
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
    difference()
    {
        cube(RACK_EAR_SIZE);
        for (i = [0 : 2])
        {
            z = i * RACK_EAR_HOLE_SPACING + RACK_EAR_HOLE_OFFSET;
            if (RACK_EAR_TYPE == "square")
                translate([RACK_EAR_SIZE[0]/2, RACK_EAR_SIZE[1]/2, z]) cube(RACK_EAR_HOLE_SIZE_SQUARE, center=true);
            else if (RACK_EAR_TYPE == "round")
                translate([RACK_EAR_SIZE[0]/2,RACK_EAR_SIZE[1]/2,z]) rotate([90,0,0]) cylinder(h=RACK_EAR_SIZE[1]*2, d=RACK_EAR_HOLE_SIZE_ROUND, center=true, $fn=32);
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
        draw_rack_ears(rackUnits, depth);
    }
}