include <utility.scad>

HDD_35_DIMS = [INCH_TO_MM(4), INCH_TO_MM(5.75), 26]; // 101.6, 146.05, 26
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

HDD_MOUNT_HOLE_DIAMETER = 2.5;

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
