// Helpers
include <global.scad>

// PC Components
use <mainboard.scad>
use <psu.scad>
use <hdd.scad>
use <fan.scad>

RACK_OUTER_WIDTH = 441;
RACK_OUTER_DEPTH = 400;
RACK_OUTER_HEIGHT = get_rack_height(4);
RACK_FLOOR_DIM = 6;
RACK_ROOF_DIM = 6;
RACK_WALL_DIM = 5;
RACK_FRONT_DIM = 6;
RACK_BACK_DIM = 6;
BUFFER = 11;

ATX_MB_POS = [RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER*2-ATX_MB_DIMS[0], RACK_OUTER_DEPTH-RACK_BACK_DIM-ATX_MB_DIMS[1], RACK_FLOOR_DIM+MB_STANDOFF_HEIGHT+MB_OFFSET_Z];
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

FRONT = 1;
LEFT = 1;
RIGHT = 0;
FLOOR = 1;
ROOF = 0;
BACK = 1;
JOINERY = 0;

EXPLODED = 0;
SECTION = 0;

MAINBOARD = 0;
FANS = 0;
PSU = 0;
DRIVES = 0;

// RACK FLOOR
if (FLOOR == 1)
{
    if (EXPLODED == 1)
        draw_floor_exploded();
    else
        draw_floor_section(SECTION);
}

// RACK LEFT WALL
if (LEFT == 1)
{
    if (EXPLODED == 1)
        draw_left_panel_exploded();
    else
        draw_left_panel_section(SECTION);

}

// RACK RIGHT WALL
if (RIGHT == 1)
{
    if (EXPLODED == 1)
        draw_right_panel_exploded();
    else
        draw_right_panel_section(SECTION);
}

// RACK ROOF
if (ROOF == 1)
{
    difference()
    {
        color("yellow") translate([0,0,RACK_OUTER_HEIGHT-RACK_ROOF_DIM]) union()
        {
            translate([0,RACK_FRONT_DIM,0]) cube([RACK_OUTER_WIDTH, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_ROOF_DIM]);
            // wall mounting points
            translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,-10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,-10]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
            translate([RACK_WALL_DIM,RACK_OUTER_DEPTH/2-10,-30]) cube([10,20,20]);
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH/2-10,-30]) cube([10,20,20]);
        }
        draw_left_side_fasteners($fn=64);
        draw_right_side_fasteners($fn=64);
        draw_front_fasteners($fn=64);
    }
}


PCI_CUTOUT_DIMS = [16,RACK_BACK_DIM+EPSILON*2,103.5];
PCI_CUTOUT_X = [14.17,34.49,54.81,75.13,95.45,115.77,136.09];

          
// RACK BACK
if (BACK == 1)
{
    if (EXPLODED == 1)
        draw_back_exploded();
    else
        draw_back_section(0);
}

module draw_back_exploded()
{
    for (i = [0:2])
    {
        translate([10*i,0,0]) draw_back_section(i+1);
    }
}

module draw_back_section(section=0)
{
    intersection()
    {
        color("lightblue") union()
        {
            difference()
            {
                union()
                {
                    // draw_fan_mounting_holes_offset
                    translate([RACK_WALL_DIM+BUFFER+5,RACK_OUTER_DEPTH-RACK_BACK_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) draw_fan_mounting_holes_offset(80,RACK_BACK_DIM,5);
                    translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-85,RACK_OUTER_DEPTH-RACK_BACK_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) draw_fan_mounting_holes_offset(80,RACK_BACK_DIM,5);
                    
                    intersection()
                    {
                        difference()
                        {
                            // honeycomb
                            translate([0,RACK_OUTER_DEPTH,0]) rotate([90,0,0]) linear_extrude(RACK_FRONT_DIM) honeycomb(RACK_OUTER_WIDTH, RACK_OUTER_HEIGHT,10,2);

                        }
                        union()
                        {
                            // draw_fan_through_hole
                            translate([RACK_WALL_DIM+BUFFER+5,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,ATX_MB_POS[2]+8]) cube([80,RACK_BACK_DIM+EPSILON*2,get_fan_spacing(80)+58]);
                            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-157,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) cube([152,RACK_BACK_DIM+EPSILON*2,80]);
                        }
                    }
                }
                // draw_fan_mounting_holes
                translate([RACK_WALL_DIM+BUFFER+5,RACK_OUTER_DEPTH-RACK_BACK_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) draw_fan_mounting_holes(80,RACK_BACK_DIM);
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-85,RACK_OUTER_DEPTH-RACK_BACK_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) draw_fan_mounting_holes(80,RACK_BACK_DIM);
            }
            difference()
            {
                union()
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

                // cutout to allow pci card tab through
                translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+112]) cube([150.5,14,10]);
                
                // thin out the back wall a bit to make room for pci cards
                translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,RACK_FLOOR_DIM+3]) cube([150.5,2,PCI_CUTOUT_DIMS[2]+8]);
                
                // cutout slits for pci retainment bracket screws
                hull()
                {
                    translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151+150.5/4,RACK_OUTER_DEPTH+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+112+35]) rotate([90,0,0]) cylinder(h=RACK_BACK_DIM+3,d=_get_head_dia("M3x8"));
                    translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151+150.5/4,RACK_OUTER_DEPTH+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+112+20]) rotate([90,0,0]) cylinder(h=RACK_BACK_DIM+3,d=_get_head_dia("M3x8"));
                }
                hull()
                {
                    translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151+150.5/4*3,RACK_OUTER_DEPTH+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+112+35]) rotate([90,0,0]) cylinder(h=RACK_BACK_DIM+EPSILON*2,d=_get_head_dia("M3x8"));
                    translate([ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2+4.151+150.5/4*3,RACK_OUTER_DEPTH+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+112+20]) rotate([90,0,0]) cylinder(h=RACK_BACK_DIM+EPSILON*2,d=_get_head_dia("M3x8"));
                }

                // cutouts to be replaced by honeycomb
                translate([RACK_WALL_DIM+BUFFER+5,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,ATX_MB_POS[2]+8]) cube([80,RACK_BACK_DIM+EPSILON*2,get_fan_spacing(80)+58]);
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-157,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-BUFFER-90]) cube([150,RACK_BACK_DIM+EPSILON*2,80]);

                // cutouts for joinery
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-157-30.5,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-15]) cube([60+1,RACK_BACK_DIM/2+0.5,10+1]);
                translate([RACK_WALL_DIM+BUFFER+85-30.5,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-15]) cube([60+1,RACK_BACK_DIM/2+0.5,10+1]);


                draw_mb_io_cutout();
                draw_left_side_fasteners($fn=64);
                draw_right_side_fasteners($fn=64);
                
                for(x=PCI_CUTOUT_X)
                {
                    translate([x+ATX_MB_POS[0]-PCI_CUTOUT_DIMS[0]/2,RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z]) cube(PCI_CUTOUT_DIMS);
                }
            }
        }
    
        if (section == 0)
            translate([-EPSILON,RACK_OUTER_DEPTH/2,-EPSILON]) cube([RACK_OUTER_WIDTH+EPSILON*2,RACK_OUTER_DEPTH/2+EPSILON,RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 1)
            translate([-EPSILON,RACK_OUTER_DEPTH/2+EPSILON,-EPSILON]) cube([RACK_WALL_DIM+BUFFER+87+EPSILON,RACK_OUTER_DEPTH/2+EPSILON,RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 2)
            union()
            {
                translate([RACK_WALL_DIM+BUFFER+87,RACK_OUTER_DEPTH/2+EPSILON,-EPSILON]) cube([152.65,RACK_OUTER_DEPTH/2+EPSILON,RACK_OUTER_HEIGHT+EPSILON*2]);
                translate([RACK_WALL_DIM+BUFFER+87+152.65,RACK_OUTER_DEPTH/2+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+MB_IO_CUTOUT_DIMS[2]+7]) cube([6,RACK_OUTER_DEPTH/2+EPSILON,RACK_OUTER_HEIGHT-MB_IO_CUTOUT_DIMS[2]-ATX_MB_POS[2]-4.7]);
            }
        else if (section == 3)
            union()
            {
                translate([RACK_WALL_DIM+BUFFER+87+152.65+6,RACK_OUTER_DEPTH/2+EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH-(RACK_WALL_DIM+BUFFER+87+152.65+6),RACK_OUTER_DEPTH/2+EPSILON,RACK_OUTER_HEIGHT+EPSILON*2]);
                translate([RACK_WALL_DIM+BUFFER+87+152.65,RACK_OUTER_DEPTH/2+EPSILON,-EPSILON]) cube([6,RACK_OUTER_DEPTH/2+EPSILON,ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z+MB_IO_CUTOUT_DIMS[2]+7]);
            }
    }
}

module draw_mb_io_cutout()
{
    //io cutout
    translate([ATX_MB_POS[0]+MB_IO_CUTOUT_OFFSET_X, RACK_OUTER_DEPTH-RACK_BACK_DIM-EPSILON, ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z]) cube([MB_IO_CUTOUT_DIMS[0],MB_IO_CUTOUT_DIMS[1]+1,MB_IO_CUTOUT_DIMS[2]]);
    //io inset
    translate([ATX_MB_POS[0]+MB_IO_CUTOUT_OFFSET_X-MB_IO_CUTOUT_BORDER/2, RACK_OUTER_DEPTH-RACK_BACK_DIM*2+1, ATX_MB_POS[2]+MB_IO_CUTOUT_OFFSET_Z-MB_IO_CUTOUT_BORDER/2]) cube([MB_IO_CUTOUT_DIMS[0]+MB_IO_CUTOUT_BORDER,RACK_WALL_THICKNESS,MB_IO_CUTOUT_DIMS[2]+MB_IO_CUTOUT_BORDER]);
}

// RACK FRONT
if (FRONT == 1)
{
    if (EXPLODED == 1)
        draw_front_panel_exploded();
    else
        draw_front_panel_section(0);
}

// JOINERY
if (JOINERY == 1)
{
    if (FRONT == 1)
    {
        difference()
        {
            union()
            {
                for (side = [xJ1, xJ2])
                {
                    translate([side-50,RACK_FRONT_DIM/2,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10-0.5]) cube([100,RACK_FRONT_DIM/2,10]);
                    translate([side-50,RACK_FRONT_DIM/2,RACK_FLOOR_DIM+0.5]) cube([100,RACK_FRONT_DIM/2,10]);
                    translate([side-3.5+25,RACK_FRONT_DIM,RACK_FLOOR_DIM+0.5]) cube([10,10,10]);
                    translate([side-8.5-25,RACK_FRONT_DIM,RACK_FLOOR_DIM+0.5]) cube([10,10,10]);
                    translate([side-3.5+25,RACK_FRONT_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) cube([10,10,10]);
                    translate([side-8.5-25,RACK_FRONT_DIM,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) cube([10,10,10]);
                }
            }
            draw_front_fasteners($fn=64);
        }
    }
    if (LEFT == 1)
    {
        difference()
        {
            translate([RACK_WALL_DIM+0.5,RACK_OUTER_DEPTH/2-50,RACK_OUTER_HEIGHT/2-5]) cube([9.5,100,10]);
            draw_left_side_fasteners($fn=64);
        }
    }
    if (RIGHT == 1)
    {
        difference()
        {
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH/2-50,RACK_OUTER_HEIGHT/2-5]) cube([9.5,100,10]);
            draw_right_side_fasteners($fn=64);
        }
    }
    if (FLOOR == 1)
    {
        difference()
        {
            union()
            {
                difference()
                {
                    translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,1.5-EPSILON]) cube([230,230,3],center=true);
                    translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,2-EPSILON*2]) cube([210,210,4],center=true);
                }
                translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,1.5-EPSILON]) cube([20,20,3],center=true);
            }
            draw_floor_fasteners($fn=64);
        }
    }
}

module draw_floor_fasteners()
{
    length = 6;
    headHeight = _get_head_height("M3x6");
    nutHeight = _get_nut_height("M3x6");
    spacing = 220/5;
    xOffset = RACK_OUTER_WIDTH/2;
    yOffset = RACK_OUTER_DEPTH/2;
    for(i=[0:spacing:220])
    {
        for(j=[-110,110])
        {
            translate([i+xOffset-110,yOffset+j,RACK_FLOOR_DIM+headHeight/2+20]) hole_through("M3",l=length,h=headHeight+20);
            translate([xOffset+j,i+yOffset-110,RACK_FLOOR_DIM+headHeight/2+20]) hole_through("M3",l=length,h=headHeight+20);
            translate([i+xOffset-110,yOffset+j,nutHeight-EPSILON]) nutcatch_parallel("M3",clk=NPclk);
            translate([xOffset+j,i+yOffset-110,nutHeight-EPSILON]) nutcatch_parallel("M3",clk=NPclk);
        }
    }
    
    for(x=[-5,5])
    {
        for(y=[-5,5])
        {
            translate([x+xOffset,y+yOffset,RACK_FLOOR_DIM+headHeight/2]) hole_through("M3",l=length,h=headHeight);
            translate([x+xOffset,y+yOffset,nutHeight-EPSILON]) nutcatch_parallel("M3",clk=NPclk);
        }
    }
}

// MAINBOARD
if (MAINBOARD == 1)
{
    translate(ATX_MB_POS) draw_ATX_mainboard();
}

// FRONT FANS
if (FANS == 1)
{
    for (i = [/*80,120,*/140])
    {
        translate([xFan1,5,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan(i,i,FAN_DEPTH);
        translate([xFan2,5,get_rack_height(4)/2-i/2]) translate([-i/2,0,0]) draw_fan(i,i,FAN_DEPTH);
    }
}

// PSU
if (PSU == 1)
{
    translate([RACK_WALL_DIM+BUFFER,0,RACK_FLOOR_DIM+psuHeight]) translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1],0]) rotate([0,-90,180]) translate([ATX_PSU_DIMS[0],ATX_PSU_DIMS[1],0]) rotate([0,0,180]) draw_ATX_psu();
}

// DRIVES
if (DRIVES == 1)
{
    draw_drives();
}

module draw_floor_exploded()
{
    for(x=[0,1])
    {
        for(y=[0,1])
        {
            i = y*2+x+1;
            translate([10*x,10*y,0]) draw_floor_section(i);
        }
    }
}


module draw_floor_section(section=0)
{
    intersection()
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
                        translate([ATX_MB_POS[0],ATX_MB_POS[1],ATX_MB_POS[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_standoffs(ATX_MB_DIMS, ATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, 0);
                        translate([ATX_MB_POS[0],ATX_MB_POS[1],ATX_MB_POS[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_standoffs(mATX_MB_DIMS, mATX_HOLES, MB_STANDOFF_HEIGHT, MB_STANDOFF_OUTER_DIAMETER, 0);

                    }
                    translate([ATX_MB_POS[0],ATX_MB_POS[1],ATX_MB_POS[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_mounting_holes(ATX_MB_DIMS, ATX_HOLES, 11);
                    translate([ATX_MB_POS[0],ATX_MB_POS[1],ATX_MB_POS[2]-MB_STANDOFF_HEIGHT/2]) draw_mainboard_mounting_holes(mATX_MB_DIMS, mATX_HOLES, 11);
                }
                // wall mounting points
                translate([RACK_WALL_DIM,RACK_FRONT_DIM+40,RACK_FLOOR_DIM]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_FRONT_DIM+40,RACK_FLOOR_DIM]) cube([10,RACK_OUTER_DEPTH-RACK_FRONT_DIM-RACK_BACK_DIM-50,10]);
                translate([RACK_WALL_DIM,RACK_OUTER_DEPTH/2-10,RACK_FLOOR_DIM+10]) cube([10,20,20]);
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-10,RACK_OUTER_DEPTH/2-10,RACK_FLOOR_DIM+10]) cube([10,20,20]);
                // disk drive supports
                //translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+1,RACK_FRONT_DIM+FAN_DEPTH+BUFFER+HDD_35_DIMS[0],RACK_FLOOR_DIM+HDD_35_DIMS[1]+3]) rotate([0,90,0]) cylinder(h=RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2],d=15);
                //translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+1,RACK_FRONT_DIM+FAN_DEPTH+BUFFER+HDD_25_DIMS[0],RACK_FLOOR_DIM+HDD_25_DIMS[1]+3]) rotate([0,90,0]) cylinder(h=RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2],d=15);
                difference()
                {
                    union()
                    {
                        translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+1,RACK_FRONT_DIM+FAN_DEPTH+BUFFER+HDD_35_DIMS[0]/3,-RACK_FLOOR_DIM/3+2]) scale([1,2,1]) rotate([0,90,0]) cylinder(h=RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2],d=HDD_35_DIMS[0]/2);
                        translate([ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+1,RACK_FRONT_DIM+FAN_DEPTH+BUFFER+HDD_35_DIMS[0]/2,-RACK_FLOOR_DIM/3]) scale([1,2,1]) rotate([0,90,0]) cylinder(h=RACK_OUTER_WIDTH-RACK_WALL_DIM*2-BUFFER*2-ATX_PSU_DIMS[2],d=HDD_35_DIMS[0]/2);
                    }

                    translate([-0.1,-0.1,0]) draw_drives();
                    translate([-0.1,0.1,0]) draw_drives();
                    translate([0.1,-0.1,0]) draw_drives();
                    translate([0.1,0.1,0]) draw_drives();
                }
                // psu_supports
                translate([RACK_WALL_DIM+BUFFER+5,RACK_FRONT_DIM+10,RACK_FLOOR_DIM]) cube([10,ATX_PSU_DIMS[1]-10,psuHeight]);
                translate([RACK_WALL_DIM+BUFFER+ATX_PSU_DIMS[2]-15,RACK_FRONT_DIM+31,RACK_FLOOR_DIM]) cube([20,ATX_PSU_DIMS[1]-72,psuHeight]);
            }
            
            // joinery
            difference()
            {
                translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,1.5-EPSILON]) cube([231,231,3],center=true);
                translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,2-EPSILON*2]) cube([209,209,4],center=true);
            }
            translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,1.5-EPSILON]) cube([21,21,3],center=true);

            draw_mb_io_cutout();
            // fasteners
            draw_left_side_fasteners($fn=64);
            draw_right_side_fasteners($fn=64);
            draw_front_fasteners($fn=64);
            draw_floor_fasteners($fn=64);
        }

        if (section == 0)
            translate([-EPSILON,-EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH+EPSILON*2,RACK_OUTER_DEPTH+EPSILON*2, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 1)
            translate([-EPSILON,-EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH/2+EPSILON,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 2)
            translate([RACK_OUTER_WIDTH/2,-EPSILON,-EPSILON]) cube([RACK_OUTER_WIDTH/2+EPSILON,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 3)
            translate([-EPSILON,RACK_OUTER_DEPTH/2,-EPSILON]) cube([RACK_OUTER_WIDTH/2+EPSILON,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 4)
            translate([RACK_OUTER_WIDTH/2,RACK_OUTER_DEPTH/2,-EPSILON]) cube([RACK_OUTER_WIDTH/2+EPSILON,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
    }
}

module draw_left_panel_exploded()
{
    for (i = [0:1])
    {
        translate([0,10*i,0]) draw_left_panel_section(i+1);
    }
}

module draw_left_panel_section(section=0)
{
    intersection()
    {
        difference()
        {
            color("lightgreen") union()
            {
                translate([0,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([RACK_WALL_DIM, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_OUTER_HEIGHT-RACK_FLOOR_DIM-RACK_ROOF_DIM]);
                // wall mounting points
                draw_side_mounting_points(RACK_WALL_DIM);
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
            // joinery cutouts
            translate([RACK_WALL_DIM,RACK_OUTER_DEPTH/2-50.5,RACK_OUTER_HEIGHT/2-5.5]) cube([11,100+1,10+1]);

            draw_left_side_fasteners($fn=64);
        }

        if (section == 0)
            translate([-50,-EPSILON,-EPSILON]) cube([100,RACK_OUTER_DEPTH+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 1)
            translate([-50,-EPSILON,-EPSILON]) cube([100,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 2)
            translate([-50,RACK_OUTER_DEPTH/2,-EPSILON]) cube([100,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
    }
}

module draw_right_panel_exploded()
{
    for (i = [0:1])
    {
        translate([0,10*i,0]) draw_right_panel_section(i+1);
    }
}

module draw_right_panel_section(section=0)
{
    intersection()
    {
        difference()
        {
            color("lightgreen") union()
            {
                translate([RACK_OUTER_WIDTH-RACK_WALL_DIM,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([RACK_WALL_DIM, RACK_OUTER_DEPTH-RACK_FRONT_DIM, RACK_OUTER_HEIGHT-RACK_FLOOR_DIM-RACK_ROOF_DIM]);
                // wall mounting points
                draw_side_mounting_points(RACK_OUTER_WIDTH-RACK_WALL_DIM-10);
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
            // joinery cutouts
            translate([RACK_OUTER_WIDTH-RACK_WALL_DIM-11,RACK_OUTER_DEPTH/2-50.5,RACK_OUTER_HEIGHT/2-5.5]) cube([11,100+1,10+1]);
            draw_right_side_fasteners($fn=64);
        }
        
        if (section == 0)
            translate([RACK_OUTER_WIDTH-50,-EPSILON,-EPSILON]) cube([100,RACK_OUTER_DEPTH+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 1)
            translate([RACK_OUTER_WIDTH-50,-EPSILON,-EPSILON]) cube([100,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
        else if (section == 2)
            translate([RACK_OUTER_WIDTH-50,RACK_OUTER_DEPTH/2,-EPSILON]) cube([100,RACK_OUTER_DEPTH/2+EPSILON, RACK_OUTER_HEIGHT+EPSILON*2]);
    }
}

module draw_side_mounting_points(xPos)
{
    translate([xPos,0,0])
    {
        translate([0,RACK_FRONT_DIM+40,RACK_FLOOR_DIM+10]) cube([10,20,10]);
        translate([0,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_FLOOR_DIM+10]) cube([10,20,10]);
        translate([0,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10*2]) cube([10,20,10]);
        translate([0,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10*2]) cube([10,20,10]);
        translate([0,RACK_FRONT_DIM+40,RACK_OUTER_HEIGHT/2-15]) cube([10,20,30]);
        translate([0,RACK_OUTER_DEPTH/2-60,RACK_OUTER_HEIGHT/2-15]) cube([10,120,30]);
        translate([0,RACK_OUTER_DEPTH-RACK_BACK_DIM-30,RACK_OUTER_HEIGHT/2-15]) cube([10,10,30]);
        translate([0,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5+10]) cube([10,10,10]);
        translate([0,RACK_OUTER_DEPTH-RACK_BACK_DIM-20,RACK_OUTER_HEIGHT/2-5-10]) cube([10,10,10]);
        translate([0,RACK_OUTER_DEPTH/2-20,RACK_FLOOR_DIM+10]) cube([10,10,20]);
        translate([0,RACK_OUTER_DEPTH/2+10,RACK_FLOOR_DIM+10]) cube([10,10,20]);
        translate([0,RACK_OUTER_DEPTH/2-20,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,10,20]);
        translate([0,RACK_OUTER_DEPTH/2+10,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-30]) cube([10,10,20]);
    }
}

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
                            translate([0,RACK_FRONT_DIM,0]) rotate([90,0,0]) linear_extrude(RACK_FRONT_DIM) honeycomb(RACK_OUTER_WIDTH, RACK_OUTER_HEIGHT,10,2);
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

module draw_mainboard_grid_piece_x(p1, p2)
{
    xLen = get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[0] - get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[0];
    translate(ATX_MB_POS) translate([get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[0]-2.5,get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[1]-2.5,0]) cube([xLen,5,2]);
}

module draw_mainboard_grid_piece_y(p1, p2)
{
    yLen = get_mainboard_mounting_hole_coord(p1, ATX_MB_DIMS, ATX_HOLES)[1] - get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[1];
    translate(ATX_MB_POS) translate([get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[0]-2.5,get_mainboard_mounting_hole_coord(p2, ATX_MB_DIMS, ATX_HOLES)[1]-2.5,-.25]) cube([5,yLen,2]);
}

module draw_front_fasteners()
{
    yOffset = -2;
    length = 6;
    headHeight = _get_head_height("M3x6");
    headDiameter = _get_head_dia("M3x6");
    nutHeight = _get_nut_height("M3x16");
    for (i=[5.5:22+5.5:100-5.5])
    {
        for (side = [xJ1,xJ2])
        {
            translate([side+i-50+headDiameter/2,yOffset,RACK_FLOOR_DIM+0.5+5]) rotate([90,0,0]) hole_through("M3",l=length,h=headHeight);
            translate([side+i-50+headDiameter/2,yOffset+length+0.5,RACK_FLOOR_DIM+0.5+5]) rotate([90,0,0]) nutcatch_parallel("M3",clk=NPclk);
            translate([side+i-50+headDiameter/2,yOffset,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-5-0.5]) rotate([90,0,0]) hole_through("M3",l=length,h=headHeight);
            translate([side+i-50+headDiameter/2,yOffset+length+0.5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-5-0.5]) rotate([90,0,0]) nutcatch_parallel("M3",clk=NPclk);
        }
    }
    
    // floor
    translate([xJ1-20-8.5,RACK_FRONT_DIM+5,RACK_FLOOR_DIM+10.5]) hole_through("M3",l=16,h=headHeight);
    translate([xJ1-20-8.5,RACK_FRONT_DIM+5,nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ1+30-3.5,RACK_FRONT_DIM+5,RACK_FLOOR_DIM+10.5]) hole_through("M3",l=16,h=headHeight);
    translate([xJ1+30-3.5,RACK_FRONT_DIM+5,nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ2-20-8.5,RACK_FRONT_DIM+5,RACK_FLOOR_DIM+10.5]) hole_through("M3",l=16,h=headHeight);
    translate([xJ2-20-8.5,RACK_FRONT_DIM+5,nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ2+30-3.5,RACK_FRONT_DIM+5,RACK_FLOOR_DIM+10.5]) hole_through("M3",l=16,h=headHeight);
    translate([xJ2+30-3.5,RACK_FRONT_DIM+5,nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    // roof
    translate([xJ1-20-8.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) rotate([180,0,0]) hole_through("M3",l=16,h=headHeight);
    translate([xJ1-20-8.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-nutHeight]) rotate([180,0,0]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ1+30-3.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) rotate([180,0,0]) hole_through("M3",l=16,h=headHeight);
    translate([xJ1+30-3.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-nutHeight]) rotate([180,0,0]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ2-20-8.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) rotate([180,0,0]) hole_through("M3",l=16,h=headHeight);
    translate([xJ2-20-8.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-nutHeight]) rotate([180,0,0]) nutcatch_parallel("M3",clk=NPclk);
    translate([xJ2+30-3.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-10.5]) rotate([180,0,0]) hole_through("M3",l=16,h=headHeight);
    translate([xJ2+30-3.5,RACK_FRONT_DIM+5,RACK_OUTER_HEIGHT-nutHeight]) rotate([180,0,0]) nutcatch_parallel("M3",clk=NPclk);
}

module draw_left_side_fasteners()
{
    length = 35;
    headHeight = _get_head_height("M3x30");
    nutHeight = _get_nut_height("M3x30");
    xPos = RACK_WALL_DIM+5;
    draw_side_fasteners(xPos,length,headHeight,nutHeight);
    
    for (i=[5.5:22+5.5:100-5.5])
    {
        translate([0,RACK_OUTER_DEPTH/2+i-50,RACK_OUTER_HEIGHT/2]) union()
        {
            rotate([0,-90,0]) hole_through("M3",l=12,h=headHeight);
            translate([xPos+5-2.4,0,0]) rotate([0,-90,0]) nutcatch_parallel("M3",clk=NPclk);
        }
    }
}

module draw_right_side_fasteners()
{
    length = 35;
    headHeight = _get_head_height("M3x30");
    nutHeight = _get_nut_height("M3x30");
    xPos = RACK_OUTER_WIDTH-RACK_WALL_DIM-5;
    draw_side_fasteners(xPos,length,headHeight,nutHeight);
    
    for (i=[5.5:22+5.5:100-5.5])
    {
        translate([RACK_OUTER_WIDTH,RACK_OUTER_DEPTH/2+i-50,RACK_OUTER_HEIGHT/2]) union()
        {
            rotate([0,90,0]) hole_through("M3",l=12,h=headHeight);
            translate([-RACK_WALL_DIM-10+nutHeight,0,0]) rotate([0,90,0]) nutcatch_parallel("M3",clk=NPclk);
        }
    }
}

module draw_side_fasteners(xPos,length,headHeight,nutHeight)
{
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-25,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-25,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3",clk=NPclk);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,RACK_OUTER_HEIGHT]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,RACK_OUTER_HEIGHT-35+nutHeight]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2+15]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,RACK_OUTER_HEIGHT/2-15+nutHeight]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,RACK_OUTER_HEIGHT/2+15]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,RACK_OUTER_HEIGHT/2-15+nutHeight]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_OUTER_DEPTH/2+20,RACK_FLOOR_DIM+25]) rotate([-90,0,0]) hole_through("M3",l=40,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH/2-20+nutHeight,RACK_FLOOR_DIM+25]) rotate([-90,0,0]) nutcatch_parallel("M3",clk=NPclk);
    translate([xPos,RACK_OUTER_DEPTH/2+20,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-25]) rotate([-90,0,0]) hole_through("M3",l=40,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH/2-20+nutHeight,RACK_OUTER_HEIGHT-RACK_ROOF_DIM-25]) rotate([-90,0,0]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_FRONT_DIM+55,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+55,35]) nutcatch_parallel("M3",clk=NPclk);
    translate([xPos,RACK_FRONT_DIM+45,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_FRONT_DIM+45,35]) nutcatch_parallel("M3",clk=NPclk);

    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-25,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-25,35]) nutcatch_parallel("M3",clk=NPclk);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,0]) rotate([180,0,0]) hole_through("M3",l=length,h=headHeight);
    translate([xPos,RACK_OUTER_DEPTH-RACK_BACK_DIM-15,35]) nutcatch_parallel("M3",clk=NPclk);

    translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1]/4*3,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) hole_through("M3",l=length,h=headHeight);
    translate([RACK_WALL_DIM+BUFFER+15-nutHeight,RACK_FRONT_DIM+ATX_PSU_DIMS[1]/4*3,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) nutcatch_parallel("M3",clk=NPclk);
    translate([0,RACK_FRONT_DIM+ATX_PSU_DIMS[1]-10,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) hole_through("M3",l=length,h=headHeight);
    translate([RACK_WALL_DIM+BUFFER+15-nutHeight,RACK_FRONT_DIM+ATX_PSU_DIMS[1]-10,RACK_FLOOR_DIM+5]) rotate([0,-90,0]) nutcatch_parallel("M3",clk=NPclk);
}

module draw_drives()
{
    for(x=[xFan1,xFan2])
    {
        for (i = [0 : 3])
        {
            translate([x-70+HDD_35_DIMS[2]+hddSpacing*i,yDrivePos,RACK_FLOOR_DIM+HDD_35_DIMS[1]+3]) rotate([-90,0,0]) rotate([0,-90,0]) draw_hdd("hdd");
            translate([x-70+HDD_25_DIMS[2]*2+ssdSpacing*i,yDrivePos,RACK_FLOOR_DIM+HDD_25_DIMS[1]]) rotate([-90,0,0]) rotate([0,-90,0]) draw_hdd("ssd");
            translate([x-70+HDD_25_DIMS[2]*1.75+ssdSpacing*i-HDD_25_DIMS[2]/2,RACK_FRONT_DIM,RACK_FLOOR_DIM]) cube([HDD_25_DIMS[2]/2,HDD_35_DIMS[0]*2,30]);
        }
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