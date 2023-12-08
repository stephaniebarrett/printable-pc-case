// Helpers
include <global.scad>

// PC Components
use <mainboard.scad>
use <psu.scad>
use <hdd.scad>
use <fan.scad>

RACK_OUTER_WIDTH = 441;
RACK_OUTER_DEPTH = 440;
RACK_OUTER_HEIGHT = get_rack_height(4);
RACK_FLOOR_DIM = 5;
RACK_ROOF_DIM = 5;
RACK_WALL_DIM = 5;
RACK_FRONT_DIM = 6;
RACK_BACK_DIM = 5;
BUFFER = 11;

ATX_MB_POS = [RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER*2-ATX_MB_DIMS[0], RACK_OUTER_DEPTH-RACK_BACK_DIM-ATX_MB_DIMS[1], RACK_FLOOR_DIM];
ATX_PSU_POS = [RACK_WALL_DIM+BUFFER, RACK_FRONT_DIM+ATX_PSU_DIMS[1], RACK_FLOOR_DIM];

// FRONT FAN POSITIONS
x = (RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-ATX_PSU_DIMS[2]-ATX_PSU_POS[0]-140*2) / 3;
xFan1 = RACK_OUTER_WIDTH-BUFFER-70-x;
xFan2 = RACK_OUTER_WIDTH-BUFFER-210-x*2;
xFanMid = xFan2+(xFan1-xFan2)/2;

xJ1 = xFanMid;
xJ2 = ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+((xFan2-70)-(ATX_PSU_POS[0]+ATX_PSU_DIMS[2]))/2;

// HDD POSITIONS
hddHeight = (RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM-HDD_35_DIMS[0])/2;
hddSpacing = HDD_35_DIMS[2]+(140-HDD_35_DIMS[2]*4)/3;
ssdSpacing = HDD_25_DIMS[2]+(140-HDD_25_DIMS[2]*6)/3;
yDrivePos = RACK_FRONT_DIM+FAN_DEPTH+BUFFER;

psuHeight = (RACK_OUTER_HEIGHT-RACK_FLOOR_DIM-RACK_ROOF_DIM-ATX_PSU_DIMS[0])/2;

// DOVETAILS
tail_width = 5;
tail_count = 1;
board_width = 10;
angle = 15;
board_thickness = 10;
pin_width = pin_width(tail_width = tail_width, tail_count=tail_count, board_width=board_width);

PART = 1;
SECTION = 0;

module draw_mainboard_grid_piece_x(p1, p2)
{
    xLen = get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[0] - get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[0];
    translate(ATX_MB_POS) translate([get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[0]-2.5,get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[1]-2.5,0]) cube([xLen,5,3]);
}

module draw_mainboard_grid_piece_y(p1, p2)
{
    yLen = get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[1] - get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[1];
    translate(ATX_MB_POS) translate([get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[0]-2.5,get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[1]-2.5,-.25]) cube([5,yLen,3]);
}

// RACK FLOOR
//if (PART == 0 || PART == 1)
{
    difference()
    {
        color("yellow") union()
        {
            difference()
            {
                union()
                {
                    translate([0,RACK_FRONT_DIM,0]) cube([RACK_OUTER_WIDTH, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_FLOOR_DIM]);
                    // mb standoffs
                    translate(ATX_MB_POS) draw_mainboard_standoffs(ATX_MB_DIMS, ATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, 0);
                    translate(ATX_MB_POS) draw_mainboard_standoffs(mATX_MB_DIMS, mATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, 0);
                    // mb grid
                    draw_mainboard_grid_piece_x(0, 1);
                    draw_mainboard_grid_piece_x(3, 5);
                    draw_mainboard_grid_piece_x(6, 8);
                    draw_mainboard_grid_piece_y(0, 6);
                    draw_mainboard_grid_piece_y(1, 7);
                    draw_mainboard_grid_piece_y(2, 8);
                }
                translate(ATX_MB_POS) draw_mainboard_mounting_holes(ATX_MB_DIMS, ATX_HOLES, 11);
                translate(ATX_MB_POS) draw_mainboard_mounting_holes(mATX_MB_DIMS, mATX_HOLES, 11);
            }
            // wall mounting points
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_FLOOR_DIM]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_FLOOR_DIM]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            // disk drive supports
            intersection()
            {
                difference()
                {
                    translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+1,RACK_FRONT_DIM+FAN_DEPTH+BUFFER+HDD_35_DIMS[1]/2-5,RACK_FLOOR_DIM-11]) rotate([-15,0,0]) scale([1,1.75,1]) rotate([0,90,0]) cylinder(h=RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2],r=hddHeight+10,$fn=256);
                    translate([0,-HDD_25_DIMS[1]/3,0]) draw_drives();
                    translate([0,HDD_25_DIMS[1]/3,0]) draw_drives();
                }
                translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2],RACK_FRONT_DIM+FAN_DEPTH,RACK_FLOOR_DIM]) cube([RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2]+2,HDD_25_DIMS[1]*1.5,hddHeight+5]);
            }
            // psu_supports
            translate([RACK_WALL_DIM+BUFFER+5,RACK_FRONT_DIM+10,RACK_FLOOR_DIM]) cube([10,ATX_PSU_DIMS[1]-10,psuHeight]);
            translate([RACK_WALL_DIM+BUFFER+ATX_PSU_DIMS[2]-15,RACK_FRONT_DIM+31,RACK_FLOOR_DIM]) cube([20,ATX_PSU_DIMS[1]-31,psuHeight]);
        }
            draw_left_side_fasteners($fn=64);
            draw_right_side_fasteners($fn=64);
    }
}

// RACK LEFT WALL
//if (PART == 0 || PART == 2)
{
    difference()
    {
        color("lightgreen") union()
        {
            translate([0,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([RACK_WALL_DIM, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_OUTER_HEIGHT-RACK_FLOOR_DIM-RACK_ROOF_DIM]);
            // wall mounting points
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_FLOOR_DIM+10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10*2]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT/2-15]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-60,30]);
            translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5+10]) cube([10,10,10]);
            translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5-10]) cube([10,10,10]);
        }
        translate([RACK_WALL_DIM+10.5,RACK_FRONT_DIM+35,RACK_OUTER_HEIGHT/2-5.5]) rotate([0,-90,0]) board_with_dovetail_tails(
            board_length=20,
            board_width=board_width+1,
            board_thickness=board_thickness+0.5,
            tail_length=5,
            tail_width=tail_width+0.5,
            pin_width=pin_width+0.5,
            tail_count=tail_count,
            angle=angle
        );
        draw_left_side_fasteners($fn=64);
    }
}

// RACK RIGHT WALL
if (PART == 0 || PART == 3)
{
    difference()
    {
        color("lightgreen") union()
        {
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([RACK_WALL_DIM, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_OUTER_HEIGHT-RACK_FLOOR_DIM-RACK_ROOF_DIM]);
            // wall mounting points
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_FLOOR_DIM+10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10*2]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT/2-15]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-60,30]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5+10]) cube([10,10,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5-10]) cube([10,10,10]);
        }
        translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-9.5,RACK_FRONT_DIM+35,RACK_OUTER_HEIGHT/2-5.5]) rotate([0,-90,0]) board_with_dovetail_tails(
            board_length=20,
            board_width=board_width+1,
            board_thickness=board_thickness+0.5,
            tail_length=5,
            tail_width=tail_width+0.5,
            pin_width=pin_width+0.5,
            tail_count=tail_count,
            angle=angle
        );
        draw_right_side_fasteners($fn=64);
    }
}

// RACK ROOF
if (PART == 0 || PART == 4)
{
    difference()
    {
        color("yellow") translate([0,0,RACK_OUTER_HEIGHT-RACK_ROOF_DIM]) union()
        {
            translate([0,RACK_FRONT_DIM,0]) cube([RACK_OUTER_WIDTH, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_ROOF_DIM]);
            // wall mounting points
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,-10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,-10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
        }
        draw_left_side_fasteners($fn=64);
        draw_right_side_fasteners($fn=64);
    }
}
if (PART == 0 || PART == 5)
{
    // RACK BACK
    color("lightblue") union()
    {
        translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM,RACK_FLOOR_DIM]) cube([RACK_OUTER_WIDTH-RACK_WALL_DIM*2,RACK_BACK_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM]);
        translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-10,RACK_FLOOR_DIM]) cube([10,10,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM]);
        translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-10,RACK_FLOOR_DIM]) cube([10,10,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM]);
        translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_FLOOR_DIM+20]) cube([10,20,10]);
        translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_FLOOR_DIM+20]) cube([10,20,10]);
        translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,20,10]);
        translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,20,10]);
        translate([RACK_WALL_DIM,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5]) cube([10,10,10]);
        translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5]) cube([10,10,10]);
    }
}

// RACK FRONT
//if (PART == 0 || PART == 6)
{
    draw_front_panel_section(SECTION);
    //draw_front_panel_exploded();
}

// JOINERY
//if (PART == 0 || PART == 7)
{
    difference()
    {
        union()
        {
            for (side = [xJ1, xJ2])
            {
                translate([side-50,RACK_FRONT_DIM/2,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10-0.5]) cube([100,RACK_FRONT_DIM/2,10]);
                translate([side-50,RACK_FRONT_DIM/2,RACK_FLOOR_DIM+0.5]) cube([100,RACK_FRONT_DIM/2,10]);
            }
        }
        draw_front_fasteners($fn=64);
    }
}

// MAINBOARD
//%translate([ATX_MB_POS[0], ATX_MB_POS[1], ATX_MB_POS[2]+4.5]) draw_ATX_mainboard();

// FRONT FANS
/*
for (i = [80,120,140])
{
    translate([xFan1,5,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan(i,i,FAN_DEPTH);
    translate([xFan2,5,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan(i,i,FAN_DEPTH);
}
*/

module draw_front_panel_exploded()
{
    for (i = [0:2])
    {
        translate([10*i,0,0]) draw_front_panel_section(i+1);
    }
}

module draw_front_panel_section(section=0)
{
    intersection()
    {
        color("lightblue") union()
        {
            difference()
            {
                union()
                {
                    // ensure mounting circles exist in the honeycomb for the various fan sizes
                    for (i = [80,120,140])
                    {
                        translate([xFan1,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes_offset(i,RACK_FRONT_DIM,3);
                        translate([xFan2,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes_offset(i,RACK_FRONT_DIM,3);
                    }
                    // build honeycomb sections
                    intersection()
                    {
                        difference()
                        {
                            translate([0,RACK_FRONT_DIM,0]) rotate([90,0,0]) linear_extrude(RACK_FRONT_DIM) honeycomb(RACK_OUTER_WIDTH, RACK_OUTER_HEIGHT, 10, 2);

                        }
                        union()
                        {
                            translate([xFan1,0,get_rack_height(4)/2-70]) translate([-70,0,0]) draw_fan_through_hole(140,140,RACK_FRONT_DIM);
                            translate([xFan2,0,get_rack_height(4)/2-70]) translate([-70,0,0]) draw_fan_through_hole(140,140,RACK_FRONT_DIM);
                        }
                    }
                }
                // punch through the fan mounting holes
                for (i = [80,120,140])
                {
                    translate([xFan1,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes(i,RACK_FRONT_DIM*2);
                    translate([xFan2,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes(i,RACK_FRONT_DIM*2);
                }
            }
            // cut holes into the solid panel
            difference()
            {
                cube([RACK_OUTER_WIDTH,RACK_FRONT_DIM,RACK_OUTER_HEIGHT]);
                // fan through holes
                translate([RACK_OUTER_WIDTH-BUFFER-70-x,-1,get_rack_height(4)/2-70]) translate([-70,0,0]) draw_fan_through_hole(140,140,RACK_FRONT_DIM+2);
                translate([RACK_OUTER_WIDTH-BUFFER-210-x*2,-1,get_rack_height(4)/2-70]) translate([-70,0,0]) draw_fan_through_hole(140,140,RACK_FRONT_DIM+2);
                for (i = [80,120,140])
                {
                    translate([xFan1,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes(i,RACK_FRONT_DIM);
                    translate([xFan2,0,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan_mounting_holes(i,RACK_FRONT_DIM);
                }
                // psu cutouts
                translate([RACK_WALL_DIM+BUFFER,0,RACK_FLOOR_DIM+psuHeight]) union()
                {
                    translate([10,-1,10]) cube([ATX_PSU_DIMS[2]-20,RACK_FRONT_DIM+2,ATX_PSU_DIMS[0]-20]);
                    translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1],0]) rotate([0,-90,180]) union()
                    {
                        translate([ATX_PSU_DIMS[0],ATX_PSU_DIMS[1],0]) rotate([0,0,180]) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
                        rotate([0,180,0]) translate([0,ATX_PSU_DIMS[1],-ATX_PSU_DIMS[2]]) rotate([0,0,180]) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
                    }
                }
                // joinery cutouts
                translate([xJ1-50.5,RACK_FRONT_DIM/2-0.5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10-1]) cube([100+1,RACK_FRONT_DIM/2+1,10+1]);
                translate([xJ1-50.5,RACK_FRONT_DIM/2-0.5,RACK_FLOOR_DIM]) cube([100+1,RACK_FRONT_DIM/2+1,10+1]);
                translate([xJ2-50.5,RACK_FRONT_DIM/2-0.5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10-1]) cube([100+1,RACK_FRONT_DIM/2+1,10+1]);
                translate([xJ2-50.5,RACK_FRONT_DIM/2-0.5,RACK_FLOOR_DIM]) cube([100+1,RACK_FRONT_DIM/2+1,10+1]);
                draw_front_fasteners($fn=64);
                draw_left_side_fasteners($fn=64);
                draw_right_side_fasteners($fn=64);
            }
            // wall mounting points
            difference()
            {
                union()
                {
                    translate([RACK_WALL_DIM,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([10,40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM]);
                    translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_FLOOR_DIM+20]) cube([10,20,10]);
                    translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,20,10]);
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([10,40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM]);
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_FLOOR_DIM+20]) cube([10,20,10]);
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,20,10]);
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT/2-5]) cube([10,10,10]);
                    translate([RACK_WALL_DIM+10,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([xJ2-RACK_WALL_DIM-60.5,10,psuHeight]);
                    translate([RACK_WALL_DIM+10,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([BUFFER+5-10,ATX_PSU_DIMS[1],psuHeight]);

                    translate([RACK_WALL_DIM+10,RACK_FRONT_DIM+35,RACK_OUTER_HEIGHT/2-5]) rotate([0,-90,0]) board_with_dovetail_tails(
                        board_length=19.75,
                        board_width=board_width,
                        board_thickness=board_thickness,
                        tail_length=5,
                        tail_width=tail_width,
                        pin_width=pin_width,
                        tail_count=tail_count,
                        angle=angle
                    );
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM,RACK_FRONT_DIM+35,RACK_OUTER_HEIGHT/2-5]) rotate([0,-90,0]) board_with_dovetail_tails(
                        board_length=19.75,
                        board_width=board_width,
                        board_thickness=board_thickness,
                        tail_length=5,
                        tail_width=tail_width,
                        pin_width=pin_width,
                        tail_count=tail_count,
                        angle=angle
                    );
                }
                draw_left_side_fasteners($fn=64);
                draw_right_side_fasteners($fn=64);
            }
            // add in the rack ears
            for (i = [0 : 3])
            {
                z = i * RACK_EAR_SIZE[2];
                translate([-RACK_EAR_SIZE[0],0,z]) draw_rack_ear();
                translate([RACK_OUTER_WIDTH,0,z]) draw_rack_ear();
            }
        }
        if (section == 0)
            translate([-RACK_EAR_SIZE[0]-EPSILON,-EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH+RACK_EAR_SIZE[0]*2+EPSILON*2,200,RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 1)
            translate([-RACK_EAR_SIZE[0]-EPSILON,-EPSILON,-EPSILON]) cube([RACK_EAR_SIZE[0]+xJ2+EPSILON,200,RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 2)
            translate([xJ2,-EPSILON,-EPSILON]) cube([xJ1-xJ2,100,RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 3)
            translate([xJ1,-EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH+RACK_EAR_SIZE[0]+EPSILON-xJ1,200,RACK_OUTER_HEIGHT+EPSILON*2]);
    }
}

module draw_front_fasteners()
{
    yOffset = -2;
    length = 6;
    headHeight = _get_head_height("M3x6");
    headDiameter = _get_head_dia("M3x6");
    for (i=[5.5:22+5.5:100-5.5])
    {
        for (side = [xJ1,xJ2])
        {
            translate([side+i-50+headDiameter/2,yOffset,RACK_FLOOR_DIM+0.5+5]) rotate([90,0,0]) hole_through("M3",l=length,h=headHeight);
            translate([side+i-50+headDiameter/2,yOffset+length+0.5,RACK_FLOOR_DIM+0.5+5]) rotate([90,0,0]) nutcatch_parallel("M3");
            translate([side+i-50+headDiameter/2,yOffset,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-5-0.5]) rotate([90,0,0]) hole_through("M3",l=length,h=headHeight);
            translate([side+i-50+headDiameter/2,yOffset+length+0.5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-5-0.5]) rotate([90,0,0]) nutcatch_parallel("M3");
        }
    }
}

module draw_left_side_fasteners()
{
    length = 35;
    headHeight = _get_head_height("M3x30");
    nutHeight = _get_nut_height("M3x30");
    xPos = RACK_WALL_DIM+5;
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2+15]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2-15+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+55,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,35]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,35]) nutcatch_parallel("M3");

    translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1]/4*3,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) hole_through("M3",l=length,h=headHeight);
    translate([RACK_WALL_DIM+BUFFER+15-nutHeight,RACK_FRONT_DIM+ATX_PSU_DIMS[1]/4*3,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) nutcatch_parallel("M3");

    translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1]-10,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) hole_through("M3",l=length,h=headHeight);
    translate([RACK_WALL_DIM+BUFFER+15-nutHeight,RACK_FRONT_DIM+ATX_PSU_DIMS[1]-10,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) nutcatch_parallel("M3");
}

module draw_right_side_fasteners()
{
    length = 35;
    headHeight = _get_head_height("M3x30");
    nutHeight = _get_nut_height("M3x30");
    xPos = RACK_OUTER_WIDTH-RACK_WALL_DIM-5;
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2+15]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2-15+nutHeight]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+55,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,35]) nutcatch_parallel("M3");

    translate([xPos,RACK_FRONT_DIM+45,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,35]) nutcatch_parallel("M3");
}

module draw_drives()
{
    for (i = [0 : 3])
    {
        translate([xFan1-70+HDD_35_DIMS[2]+hddSpacing*i,yDrivePos,hddHeight]) rotate([0,-90,0]) draw_hdd("hdd");
        translate([xFan1-70+HDD_25_DIMS[2]*2+ssdSpacing*i,yDrivePos,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-HDD_25_DIMS[0]-BUFFER]) rotate([0,-90,0]) draw_hdd("ssd");
        translate([xFan1-70+HDD_25_DIMS[2]*2+ssdSpacing*i,yDrivePos,RACK_FLOOR_DIM+BUFFER]) rotate([0,-90,0]) draw_hdd("ssd");
    }
    for (i = [0 : 3])
    {
        translate([xFan2-70+HDD_35_DIMS[2]+hddSpacing*i,yDrivePos,hddHeight]) rotate([0,-90,0]) draw_hdd("hdd");
        translate([xFan2-70+HDD_25_DIMS[2]*2+ssdSpacing*i,yDrivePos,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-HDD_25_DIMS[0]-BUFFER]) rotate([0,-90,0]) draw_hdd("ssd");
        translate([xFan2-70+HDD_25_DIMS[2]*2+ssdSpacing*i,yDrivePos,RACK_FLOOR_DIM+BUFFER]) rotate([0,-90,0]) draw_hdd("ssd");
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