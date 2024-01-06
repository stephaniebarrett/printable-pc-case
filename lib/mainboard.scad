include <utility.scad>

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
MB_IO_CUTOUT_DIMS = [159, 0, 44.7]; // when using this, use your rack wall thickness in place of the y value here.
MB_IO_CUTOUT_OFFSET_X = INCH_TO_MM(.65+5.196-.01);
MB_IO_CUTOUT_OFFSET_Z = -2.3;
MB_IO_CUTOUT_BORDER = 2.6;
MB_OFFSET_Z = -1.7;
REAR_IO_WALL_Y = 1.7;

module draw_ATX_mainboard(center=false)
{
    offset = center ? [-ATX_MB_DIMS[0]/2, -ATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(offset, ATX_MB_DIMS, ATX_HOLES, 0);
}

module draw_mATX_mainboard(center=false)
{
    offset = center ? [-mATX_MB_DIMS[0]/2, -mATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(offset, mATX_MB_DIMS, mATX_HOLES, mATX_xOFFSET);
}

module draw_mainboard(offset, dims, holes, xOffset=0)
{
    translate(offset) difference()
    {
        cube(dims);
        draw_mainboard_mounting_holes (dims, holes, 5, MB_MOUNTING_HOLE_DIAMETER, xOffset);
        draw_rearIO_inset(xOffset);
    }
}

module draw_rearIO_inset(xOffset=0)
{
    translate([MB_IO_CUTOUT_OFFSET_X-xOffset, ATX_MB_DIMS[1], ATX_MB_DIMS[2]-.99]) difference()
    {
        translate([0,-25,0]) cube([159, 25, 1]);
        translate([5,-20,-.5]) cube([159-10, 20, 2]);
    }
}

function get_mainboard_mounting_hole_coord(idx, dims, positions, xOffset=0) = [
    INCH_TO_MM(MB_HOLE_LAYOUT_INCHES[positions[idx]][0] - xOffset), // x
    dims[1] - INCH_TO_MM(MB_HOLE_LAYOUT_INCHES[positions[idx]][1])  // y
];

module draw_mainboard_mounting_holes(dims, positions, height=10, diameter=MB_MOUNTING_HOLE_DIAMETER, xOffset=0)
{
    for (i = positions)
    {
        coord = MB_HOLE_LAYOUT_INCHES[i];
        x = INCH_TO_MM(coord[0]);
        y = INCH_TO_MM(coord[1]);
            
        translate ([x - xOffset, dims[1] - y, 0]) cylinder(h = height, d = diameter, center = true, $fn = 32);
    }
}



module draw_mainboard_standoffs(dims, positions, height=MB_STANDOFF_HEIGHT, diameter=MB_STANDOFF_OUTER_DIAMETER, xOffset=0)
{
    for (i = positions)
    {
        coord = MB_HOLE_LAYOUT_INCHES[i];
        x = INCH_TO_MM(coord[0]);
        y = INCH_TO_MM(coord[1]);
            
        translate ([x - xOffset, dims[1] - y, 0]) draw_mainboard_standoff(height, diameter);
    }
}

module draw_mainboard_standoff(height=MB_STANDOFF_HEIGHT, diameter=MB_STANDOFF_OUTER_DIAMETER)
{
    difference()
    {
        cylinder(h=height, d=diameter, center=true, $fn=32);
        // TODO: replace this cutout with enough space for a threaded insert
        cylinder(h=height+EPSILON, d=2.8, center = true, $fn=32);
    }
}