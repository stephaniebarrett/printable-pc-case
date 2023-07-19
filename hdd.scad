include <global.scad>

draw_hdd_35();

module draw_hdd_35(center=false)
{
    offset = center ? -HDD_35_DIMS/2 : [0,0,0];
    difference()
    {
        cube(HDD_35_DIMS, center);
        translate(offset) draw_hdd_35_bottom_mounting_holes();
        translate(offset) draw_hdd_35_side_mounting_holes();
    }
}

module draw_hdd_35_bottom_mounting_holes()
{
    for (coord = HDD_35_BOTTOM_MOUNT_HOLES)
    {
        translate(coord) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=64);
    }
}

module draw_hdd_35_side_mounting_holes()
{
    for (coord = HDD_35_SIDE_MOUNT_HOLES)
    {
        translate(coord) rotate([0, 90, 0]) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=64);
    }
}
