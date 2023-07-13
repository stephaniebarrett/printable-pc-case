include <Text/alpha.scad>
include <utility.scad>

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

module draw_hdd_35(useLabels, center=false)
{
    offset = center ? -HDD_35_DIMS/2 : [0,0,0];
    difference()
    {
        cube(HDD_35_DIMS, center);
        translate(offset) draw_hdd_35_bottom_mounting_holes();
        translate(offset) draw_hdd_35_side_mounting_holes();
        if (useLabels)
        {
            translate(offset) draw_hdd_label("HDD", HDD_35_DIMS);
        }
    }
}

function get_hdd_dims() = HDD_35_DIMS;

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

module draw_hdd_label(label, hddDims)
{
        translate([hddDims[0]/2-getwid(label)/2, hddDims[1]/2, hddDims[2]-.99]) alpha_draw_string(0, 0, 0, label, $type="square", $cross=bold);
}