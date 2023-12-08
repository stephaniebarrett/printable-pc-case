include <global.scad>

module draw_hdd(type, drawMountingHoles=false, center=false)
{
    if (type == "ssd")
        prv_draw_hdd(HDD_25_DIMS, HDD_25_BOTTOM_MOUNT_HOLES, HDD_25_SIDE_MOUNT_HOLES, drawMountingHoles, center);

    else if (type == "hdd")
        prv_draw_hdd(HDD_35_DIMS, HDD_35_BOTTOM_MOUNT_HOLES, HDD_35_SIDE_MOUNT_HOLES, drawMountingHoles, center);
}

module draw_hdd_bottom_mounting_holes(mountingHoles)
{
    for (coord = mountingHoles)
    {
        translate(coord) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=32);
    }
}

module draw_hdd_side_mounting_holes(mountingHoles)
{
    for (coord = mountingHoles)
    {
        translate(coord) rotate([0, 90, 0]) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=32);
    }
}

// PRIVATE / HELPERS //

module prv_draw_hdd(dims, bottomHoles, sideHoles, drawMountingHoles, center)
{
    offset = center ? -dims / 2 : [0, 0, 0];
    difference()
    {
        cube(dims, center);
        if (drawMountingHoles)
        {
            translate(offset) draw_hdd_bottom_mounting_holes(bottomHoles);
            translate(offset) draw_hdd_side_mounting_holes(sideHoles);
        }
    }
}
