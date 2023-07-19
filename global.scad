include <externals/nutsnbolts/cyl_head_bolt.scad>;

function INCH_TO_MM(inch) = inch * 25.4;

EPSILON = 0.01;
// ATX board dimensions
ATX_MB_DIMS = [305, 244, 1.5748];
// Micro ATX board dimensions
mATX_MB_DIMS = [244, 244, 1.5748];
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
MB_MOUNTING_HOLE_DIAMETER = 4;
MB_STANDOFF_HEIGHT = 6;
MB_STANDOFF_OUTER_DIAMETER = 8;

// Chassis fan mounting hole size
FAN_MOUNTING_HOLE_DIAMETER = 4.3;
FAN_SIZE = 80;
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
HDD_25_DIMS = [INCH_TO_MM(2.75), INCH_TO_MM(4), 10];

HDD_35_BOTTOM_MOUNT_HOLES = [
    [3.18, HDD_35_DIMS[1]-41.28],
    [3.18, HDD_35_DIMS[1]-41.28-44.45],
    [3.18, HDD_35_DIMS[1]-41.28-76.2],
    [3.18+95.25, HDD_35_DIMS[1]-41.28],
    [3.18+95.25, HDD_35_DIMS[1]-41.28-44.45],
    [3.18+95.25, HDD_35_DIMS[1]-41.28-76.2]
];

HDD_35_SIDE_MOUNT_HOLES = [
    [0, HDD_35_DIMS[1]-28.5, 6.35],
    [0, HDD_35_DIMS[1]-28.5-101.6, 6.35],
    [HDD_35_DIMS[0], HDD_35_DIMS[1]-28.5, 6.35],
    [HDD_35_DIMS[0], HDD_35_DIMS[1]-28.5-101.6, 6.35]
];

HDD_MOUNT_HOLE_DIAMETER = INCH_TO_MM(0.138);

COMPONENT_GAP = 6;
NUMBER_OF_RACK_UNITS = 3;

RACK_EAR_SIZE = [15.875, 6, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;
RACK_WALL_THICKNESS = 6;
RACK_FLOOR_THICKNESS = 10;
RACK_ROOF_THICKNESS = 6;
RACK_WIDTH = 450.85;
RACK_DEPTH = 400;

function get_rack_height(rackUnits=1) = (rackUnits * 44.5);
function get_rack_outer_dims(rackUnits, depth) = [RACK_WIDTH, depth, get_rack_height(rackUnits)];
function get_rack_inner_dims(rackUnits, depth) = [RACK_WIDTH - RACK_WALL_THICKNESS * 2, depth, get_rack_height(rackUnits) - RACK_FLOOR_THICKNESS - RACK_ROOF_THICKNESS];
function mountingRailThickness(screwType) = _get_head_dia(screwType)*2;

RACK_OUTER_DIMS = get_rack_outer_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);
RACK_INNER_DIMS = get_rack_inner_dims(NUMBER_OF_RACK_UNITS, RACK_DEPTH);

RACK_TAB_SIZE = [30+EPSILON, 20+EPSILON, RACK_FLOOR_THICKNESS/2+EPSILON];
RACK_TAB_SIZE_SMALL = [30-.5, 20-1, RACK_FLOOR_THICKNESS/2-.5];

MB_POSITION = [RACK_WALL_THICKNESS+COMPONENT_GAP*2, 400 - mATX_MB_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS + MB_STANDOFF_HEIGHT];
PSU_POSITION = [RACK_OUTER_DIMS[0] - ATX_PSU_DIMS[0] - RACK_WALL_THICKNESS - COMPONENT_GAP*2, RACK_OUTER_DIMS[1] - ATX_PSU_DIMS[1] - RACK_WALL_THICKNESS, RACK_FLOOR_THICKNESS];

MOUNTING_SCREW_TYPE = "M3x10";
M3x10HeadHeight=_get_head_height(MOUNTING_SCREW_TYPE);
M3x10NutHeight =_get_nut_height(MOUNTING_SCREW_TYPE);
M3x10HeadDia=_get_head_dia(MOUNTING_SCREW_TYPE);

