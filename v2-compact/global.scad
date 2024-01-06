include <../ext/nutsnbolts/cyl_head_bolt.scad>;
include <../ext/honeycomb/honeycomb.scad>
include <../ext/dovetails/dovetails.scad>

include <../lib/mainboard.scad>
include <../lib/psu.scad>
include <../lib/hdd.scad>
include <../lib/fan.scad>

// through holes
THcld  = 0.4; // dia clearance for the bolt
THhcld = 1.0; // dia clearances for the head
// nutcatch parallel
NPclh = 0.2; // nut height clearance
NPclk = 0.2; // clearance aditional to nominal key width
// nutcatch sidecut
NSclh = 0.2; // height clearance
NSclsl = 0.2; // slot width clearance

RACK_EAR_TYPE = "round"; // or "square"
RACK_EAR_HOLE_SIZE_ROUND = 7;
RACK_EAR_HOLE_SIZE_SQUARE = 9.4;
RACK_EAR_SIZE = [15.875, 6, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;

RACK_OUTER_WIDTH = 441;
RACK_OUTER_DEPTH = 285;
RACK_OUTER_HEIGHT = get_rack_height(4);

RACK_FLOOR_DIM = 6;
RACK_ROOF_DIM = 6;
RACK_WALL_DIM = 4;
RACK_FRONT_DIM = 4;
RACK_BACK_DIM = 4;

BUFFER = 11;

ATX_MB_POS = [RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER*2-ATX_MB_DIMS[0], RACK_OUTER_DEPTH-RACK_BACK_DIM-ATX_MB_DIMS[1], RACK_FLOOR_DIM+MB_STANDOFF_HEIGHT+MB_OFFSET_Z];
ATX_PSU_POS = [RACK_WALL_DIM+BUFFER, RACK_FRONT_DIM+ATX_PSU_DIMS[1], RACK_FLOOR_DIM];

PCI_CUTOUT_DIMS = [16,RACK_BACK_DIM+EPSILON*2,103.5];
PCI_CUTOUT_X = [14.17,34.49,54.81,75.13,95.45,115.77,136.09];

// FRONT FAN POSITIONS
x = (RACK_OUTER_WIDTH-RACK_WALL_DIM-BUFFER-ATX_PSU_DIMS[2]-ATX_PSU_POS[0]-140*2) / 3;
xFan1 = RACK_OUTER_WIDTH-BUFFER-70-x;
xFan2 = RACK_OUTER_WIDTH-BUFFER-210-x*2;
xFanMid = xFan2+(xFan1-xFan2)/2;

xJ1 = xFanMid;
xJ2 = ATX_PSU_POS[0]+ATX_PSU_DIMS[2]+((xFan2-70)-(ATX_PSU_POS[0]+ATX_PSU_DIMS[2]))/2;

// HDD POSITIONS
hddHeight = (RACK_OUTER_HEIGHT-RACK_ROOF_DIM-RACK_FLOOR_DIM-HDD_35_DIMS[0])/2;
hddSpacing = HDD_35_DIMS[0]+5;
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
