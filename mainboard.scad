include <global.scad>

translate([0, ATX_MB_DIMS[0], 0]) draw_ATX_mainboard();
draw_mATX_mainboard(true);

module draw_ATX_mainboard(center=false)
{
    offset = center ? [-ATX_MB_DIMS[0]/2, -ATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(offset, ATX_MB_DIMS, ATX_HOLES, 0);
}

module draw_mATX_mainboard(center=false)
{
    xOffset = ATX_MB_DIMS[0] - mATX_MB_DIMS[0];
    offset = center ? [-mATX_MB_DIMS[0]/2, -mATX_MB_DIMS[1]/2, 0] : [0, 0, 0];
    draw_mainboard(offset, mATX_MB_DIMS, mATX_HOLES, xOffset);
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
    translate([INCH_TO_MM(.65+5.196-.01)-xOffset, ATX_MB_DIMS[1], ATX_MB_DIMS[2]-.99]) difference()
    {
        translate([0,-25,0]) cube([INCH_TO_MM(6.25+.008), 25, 1]);
        translate([5,-20,-.5]) cube([INCH_TO_MM(6.25+.008)-10, 20, 2]);
    }
}

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