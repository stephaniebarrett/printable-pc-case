include <Text/alpha.scad>
include <utility.scad>

// ATX board dimensions
ATX_MB_DIMS = [305, 244, INCH_TO_MM(.062)];
// Micro ATX board dimensions
mATX_MB_DIMS = [244, 244, INCH_TO_MM(.062)];
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

rearIO_string = "REAR IO";
ATX_string = "ATX MAINBOARD";
mATX_string = "MICRO ATX MAINBOARD";

// demo
module mb_demo()
{
    translate([0, ATX_MB_DIMS[0], 0]) mainboard_ATX();
    mainboard_mATX(true);
}

module draw_ATX_mainboard(useLabels, center=false)
{
    offset = center ? [-ATX_MB_DIMS[0]/2, -ATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(useLabels, offset, ATX_MB_DIMS, ATX_HOLES, ATX_string, 0);
}

module draw_mATX_mainboard(useLabels, center=false)
{
    xOffset = ATX_MB_DIMS[0] - mATX_MB_DIMS[0];
    offset = center ? [-mATX_MB_DIMS[0]/2, -mATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(useLabels, offset, mATX_MB_DIMS, mATX_HOLES, mATX_string, xOffset);
}

function get_ATX_mainboard_dims() = ATX_MB_DIMS;
function get_mATX_mainboard_dims() = mATX_MB_DIMS;

module draw_mainboard(useLabels, offset, dims, holes, label, xOffset=0)
{
    translate(offset) difference()
    {
        cube(dims);
        draw_mainboard_mounting_holes (dims, holes, xOffset);
        if (useLabels)
        {
            draw_boardType_label(label);
            draw_rearIO_label();
        }
        draw_rearIO_inset(xOffset);
    }
}

module draw_rearIO_inset(xOffset=0)
{
    translate([INCH_TO_MM(.65+5.196-.01)-xOffset, ATX_MB_DIMS[1], ATX_MB_DIMS[2]-.99]) difference()
    {
        translate([0,-25,0]) cube([INCH_TO_MM(6.25+.008), 25, 1]);
        translate([5,-20,-.5]) cube([INCH_TO_MM(6.25+.008)-10, 20, 2]);
    }
}

module draw_boardType_label(label)
{
    translate([ATX_MB_DIMS[0]/2-getwid(label)/2, ATX_MB_DIMS[1]/2, ATX_MB_DIMS[2]-.99]) alpha_draw_string(0, 0, 0, label, $type="square", $cross=bold);
}

module draw_rearIO_label()
{
    translate([INCH_TO_MM(.65+5.196-.01+(6.25+.008)/2)-getwid(rearIO_string)/2, ATX_MB_DIMS[1]-15, ATX_MB_DIMS[2]-.99]) alpha_draw_string(0, 0, 0, rearIO_string, $type="square", $cross=bold);
}

module draw_mainboard_mounting_holes(dims, positions, xOffset=0)
{
    for (i = positions)
    {
        coord = MB_HOLE_LAYOUT_INCHES[i];
        x = INCH_TO_MM(coord[0]);
        y = INCH_TO_MM(coord[1]);
            
        translate ([x - xOffset, dims[1] - y, 0]) cylinder(h = 10, r = 3, center = true, $fn = 64);
    }
}