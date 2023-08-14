include <externals/nutsnbolts/cyl_head_bolt.scad>;
include <honeycomb.scad>
include <utility.scad>

function INCH_TO_MM(inch) = inch * 25.4;

EPSILON = 0.01;

USE_HEATSETS = true;

/* CASE CONFIGURATION
    1:  - PSU back right, low
        - mATX mainboard back left
        - 2.5" (7 disks) OR 3.5" (4 disks) drive cage front right
        - 2.5" (7 disks) drive cage front left
    2:  - PSU back left, hight (above ATX MB if used)
        - mATX OR ATX mainboard back right (PSU will cover some expansion slots if ATX is used)
        - 2.5" (7 disks) drive cage front right
        - 2.5" (7 disks) OR 3.5" (3 disks) drive cage front left
*/
CASE_CONFIGURATION = 1;

MOUNTING_SCREW_TYPE = "M3x10";
M3x10HeadHeight=_get_head_height(MOUNTING_SCREW_TYPE);
M3x10NutHeight =_get_nut_height(MOUNTING_SCREW_TYPE);
M3x10HeadDia=_get_head_dia(MOUNTING_SCREW_TYPE);

M3HEATSET_DIAMETER = 4;
M3HEATSET_HEIGHT = 6;

RACK_EAR_TYPE = "round"; // or "square"
RACK_EAR_HOLE_SIZE_ROUND = 7;
RACK_EAR_HOLE_SIZE_SQUARE = 9.4;
RACK_EAR_SIZE = [15.875, 6, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;
RACK_WALL_THICKNESS = 6;
RACK_FLOOR_THICKNESS = 10;
RACK_ROOF_THICKNESS = 6;
RACK_WIDTH = INCH_TO_MM(17.375); // 441.325
RACK_DEPTH = 400;
NUMBER_OF_RACK_UNITS = 3;
RACK_TAB_SIZE = [30+EPSILON, 20+EPSILON, RACK_FLOOR_THICKNESS/2+EPSILON];
RACK_TAB_SIZE_SMALL = [30-.5, 20-1, RACK_FLOOR_THICKNESS/2-.5];
RACK_TAB_SIZE_DIFFERENCE = RACK_TAB_SIZE - RACK_TAB_SIZE_SMALL;

function get_rack_height(rackUnits=1) = (rackUnits * 44.5);
function get_rack_outer_dims(rackUnits, depth) = [RACK_WIDTH, depth, get_rack_height(rackUnits)];
function get_rack_inner_dims(rackUnits, depth) = [RACK_WIDTH - RACK_WALL_THICKNESS * 2, depth, get_rack_height(rackUnits) - RACK_FLOOR_THICKNESS - RACK_ROOF_THICKNESS];

RACK_OUTER_DIMS = get_rack_outer_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);
RACK_INNER_DIMS = get_rack_inner_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);

RACK_MODULE_JOINING_PILLAR_DIMS = [_get_head_dia(MOUNTING_SCREW_TYPE)*1.5, _get_head_dia(MOUNTING_SCREW_TYPE)*2, RACK_INNER_DIMS[2]];


// ATX board dimensions
ATX_MB_DIMS = [305, 244, 1.6];
// Micro ATX board dimensions
mATX_MB_DIMS = [244, 244, 1.6];
// ATX mounting hole positions (in inches)
MB_HOLE_LAYOUT_INCHES = [
    [.65, .4],          // A 0
    [.65+3.1, .4],      // B 1
    [.65+4.9, .4],      // C 2
    [.65+11.1, .4+.9],  // F 3
    [.65, .4+6.1],      // G 4
    [.65+4.9, .4+6.1],  // H 5
    [.65+11.1, .4+6.1], // J 6
    [.65, .4+8.95],     // K 7
    [.65+4.9, .4+8.95], // L 8
    [.65+11.1, .4+8.95] // M 9
];
// ATX mounting hole indicies (A C F G H J K L M)
ATX_HOLES = [0, 2, 3, 4, 5, 6, 7, 8, 9];
// Micro ATX mounting hole indicies (B C F H J L M R S)
mATX_HOLES = [1, 2, 3, 5, 6, 8, 9];
// Mainboard standoff sizes
MB_MOUNTING_HOLE_DIAMETER = 3.5;
MB_STANDOFF_HEIGHT = 9.5;
MB_STANDOFF_OUTER_DIAMETER = 8;
MB_IO_CUTOUT_DIMS = [159, RACK_WALL_THICKNESS, 44.7];
MB_IO_CUTOUT_OFFSET_X = INCH_TO_MM(.65+5.196-.01);
MB_IO_CUTOUT_OFFSET_Z = -2.3;
MB_IO_CUTOUT_BORDER = 2.6;
MB_OFFSET_Z = -1.7;
REAR_IO_WALL_Y = 1.7;

mATX_xOFFSET = ATX_MB_DIMS[0] - mATX_MB_DIMS[0];

// Chassis fan mounting hole size
FAN_MOUNTING_HOLE_DIAMETER = 4.3;
FAN_SIZE_FRONT = 80;
FAN_SIZE_REAR = 40;
FAN_DEPTH = 25;

// ATX power supply dimensions
ATX_PSU_DIMS = [150, 146, 86];
// ATX power supply mounting hole locations
ATX_PSU_MOUNTING_HOLES = [
    [6, 16],
    [6+114, 6],
    [6, 16+64],
    [6+138, 6+74]
];

HDD_35_DIMS = [INCH_TO_MM(4), INCH_TO_MM(5.75), 20];
HDD_25_DIMS = [INCH_TO_MM(2.75), INCH_TO_MM(4), 10]; // 69.85, 101.6, 10

// assuming power/data is facing away and label is up:
HDD_35_BOTTOM_MOUNT_HOLES = [
    [3.18, HDD_35_DIMS[1]-41.28], // far left
    [3.18, HDD_35_DIMS[1]-41.28-44.45], // middle left
    [3.18, HDD_35_DIMS[1]-41.28-76.2], // near left
    [3.18+95.25, HDD_35_DIMS[1]-41.28], // far right
    [3.18+95.25, HDD_35_DIMS[1]-41.28-44.45], // middle right
    [3.18+95.25, HDD_35_DIMS[1]-41.28-76.2] // near right
];

// assuming power/data is facing away and label is up:
HDD_35_SIDE_MOUNT_HOLES = [
    [0, HDD_35_DIMS[1]-28.5, 6.35], // far left
    [0, HDD_35_DIMS[1]-28.5-101.6, 6.35], // near left
    [HDD_35_DIMS[0], HDD_35_DIMS[1]-28.5, 6.35], // far right
    [HDD_35_DIMS[0], HDD_35_DIMS[1]-28.5-101.6, 6.35] // near right
];

// assuming power/data is facing away and label is up:
HDD_25_BOTTOM_MOUNT_HOLES = [
    [(HDD_25_DIMS[0]-61.72)/2, HDD_25_DIMS[1]-14], // far left
    [(HDD_25_DIMS[0]-61.72)/2, HDD_25_DIMS[1]-90.6], // near left
    [HDD_25_DIMS[0]-(HDD_25_DIMS[0]-61.72)/2, HDD_25_DIMS[1]-14], // far right
    [HDD_25_DIMS[0]-(HDD_25_DIMS[0]-61.72)/2, HDD_25_DIMS[1]-90.6] // near right
];

// assuming power/data is facing away and label is up:
HDD_25_SIDE_MOUNT_HOLES = [
    [0, HDD_25_BOTTOM_MOUNT_HOLES[0][1], 3],
    [0, HDD_25_BOTTOM_MOUNT_HOLES[1][1], 3],
    [HDD_25_DIMS[0], HDD_25_BOTTOM_MOUNT_HOLES[2][1], 3],
    [HDD_25_DIMS[0], HDD_25_BOTTOM_MOUNT_HOLES[3][1], 3]
];

HDD_35_CAGE_NUM_DRIVES = 4;
HDD_35_CAGE_NUM_DRIVES_CONFIG2 = 3;
HDD_25_CAGE_NUM_DRIVES = 7;

HDD_35_CAGE_OFFSET_Z = 12;
HDD_25_CAGE_OFFSET_Z = 10;

HDD_CAGE_BUFFER_X = 2;
HDD_CAGE_PILLAR_DIMS = [_get_head_dia(MOUNTING_SCREW_TYPE)*1.5, _get_head_dia(MOUNTING_SCREW_TYPE)*1.5, RACK_INNER_DIMS[2]];
HDD_CAGE_SHELF_THICKNESS = 3;

HDD_35_CAGE_SHELF_DIMS = [HDD_35_DIMS[0] + HDD_CAGE_BUFFER_X, HDD_CAGE_PILLAR_DIMS[1], HDD_CAGE_SHELF_THICKNESS];
HDD_35_CAGE_SHELF_SPACING = HDD_35_CAGE_SHELF_DIMS[2] + HDD_35_DIMS[2] + (RACK_INNER_DIMS[2] - HDD_35_CAGE_OFFSET_Z - (HDD_35_CAGE_SHELF_DIMS[2] + HDD_35_DIMS[2]) * HDD_35_CAGE_NUM_DRIVES) / HDD_35_CAGE_NUM_DRIVES;

HDD_25_CAGE_SHELF_DIMS = [HDD_25_DIMS[0] + HDD_CAGE_BUFFER_X, HDD_CAGE_PILLAR_DIMS[1], HDD_CAGE_SHELF_THICKNESS];
HDD_25_CAGE_SHELF_SPACING = HDD_25_CAGE_SHELF_DIMS[2] + HDD_25_DIMS[2] + (RACK_INNER_DIMS[2] - HDD_25_CAGE_OFFSET_Z - (HDD_25_CAGE_SHELF_DIMS[2] + HDD_25_DIMS[2]) * HDD_25_CAGE_NUM_DRIVES) / HDD_25_CAGE_NUM_DRIVES;

HDD_35_CAGE_RAIL_DIMS = [HDD_CAGE_PILLAR_DIMS[0], HDD_35_SIDE_MOUNT_HOLES[0][1] - HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1], HDD_CAGE_PILLAR_DIMS[0]];
HDD_25_CAGE_RAIL_DIMS = [HDD_CAGE_PILLAR_DIMS[0], HDD_25_SIDE_MOUNT_HOLES[0][1] - HDD_25_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1], HDD_CAGE_PILLAR_DIMS[0]];

HDD_MOUNT_HOLE_DIAMETER = 2.5;
HDD_Y_OFFSET = 30;
HDD_X_OFFSET = 5; // from RACK WIDTH

COMPONENT_GAP = 15;

function get_psu_position(configuration) =
    (configuration == 1) ?
        [RACK_OUTER_DIMS[0] - ATX_PSU_DIMS[0] - RACK_WALL_THICKNESS - COMPONENT_GAP / 3, RACK_OUTER_DIMS[1] - ATX_PSU_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS * 2]
    : (configuration == 2) ?
        [RACK_WALL_THICKNESS + COMPONENT_GAP / 3, RACK_OUTER_DIMS[1] - ATX_PSU_DIMS[1] - RACK_WALL_THICKNESS, RACK_OUTER_DIMS[2] - ATX_PSU_DIMS[2] - RACK_ROOF_THICKNESS - 1]
    : [0, 0, 0];

function get_mb_position(configuration) =
    (configuration == 1) ?
        [RACK_WALL_THICKNESS + COMPONENT_GAP, RACK_DEPTH - mATX_MB_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS + MB_STANDOFF_HEIGHT + MB_OFFSET_Z]
    : (configuration == 2) ?
        [RACK_OUTER_DIMS[0] - RACK_WALL_THICKNESS - RACK_MODULE_JOINING_PILLAR_DIMS[0] - COMPONENT_GAP / 3 - ATX_MB_DIMS[0], RACK_DEPTH - ATX_MB_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS + MB_STANDOFF_HEIGHT + MB_OFFSET_Z]
    : [0, 0, 0];

MB_POSITION = get_mb_position(CASE_CONFIGURATION);
PSU_POSITION = get_psu_position(CASE_CONFIGURATION);

PSU_FLOOR_VENT_HOLE_SIZE = 80;
PSU_FLOOR_VENT_POSITION = [PSU_POSITION[0] + ATX_PSU_DIMS[0] / 2 - PSU_FLOOR_VENT_HOLE_SIZE / 2, PSU_POSITION[1] + ATX_PSU_DIMS[1] / 2 - PSU_FLOOR_VENT_HOLE_SIZE / 2, RACK_FLOOR_THICKNESS];

// through holes
THcld  = 0.4; // dia clearance for the bolt
THhcld = 1.0; // dia clearances for the head
// nutcatch parallel
NPclh = 0.2; // nut height clearance
NPclk = 0.1; // clearance aditional to nominal key width
// nutcatch sidecut
NSclh = 0.2; // height clearance
NSclsl = 0.2; // slot width clearance

HONEYCOMB_DIAMETER = 12;
HONEYCOMB_SIZE = 1;