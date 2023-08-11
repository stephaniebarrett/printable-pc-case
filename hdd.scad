include <global.scad>

// EXAMPLE //

// ghost 3.5 HDDs
for (j = [0 : HDD_35_CAGE_NUM_DRIVES - 1])
{
    z = j * HDD_35_CAGE_SHELF_SPACING + HDD_35_CAGE_SHELF_DIMS[2];
    #translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) draw_hdd("hdd");
}

// ghost 2.5 SSDs
for (j = [0 : HDD_25_CAGE_NUM_DRIVES - 1])
{
    z = j * HDD_25_CAGE_SHELF_SPACING + HDD_25_CAGE_SHELF_DIMS[2];
    #translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) draw_hdd("ssd");
}

draw_hdd_cage("hdd");
translate([0,HDD_35_SIDE_MOUNT_HOLES[1][1]-HDD_25_SIDE_MOUNT_HOLES[1][1],0]) draw_hdd_cage("ssd");



/// PUBLIC ///

module draw_hdd(type, center=false)
{
    if (type == "ssd")
        prv_draw_hdd(HDD_25_DIMS, HDD_25_BOTTOM_MOUNT_HOLES, HDD_25_SIDE_MOUNT_HOLES);

    else if (type == "hdd")
        prv_draw_hdd(HDD_35_DIMS, HDD_35_BOTTOM_MOUNT_HOLES, HDD_35_SIDE_MOUNT_HOLES);
}

module draw_hdd_cage(type, rails=true)
{
    if (type == "ssd")
    {
        if (rails)
            draw_hdd_cage_riserWithRails(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS);
        else
            draw_hdd_cage_riser(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS);
    }
    else if (type == "hdd")
    {
        if (rails)
            draw_hdd_cage_riserWithRails(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_SHELF_SPACING, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS);
        else
            draw_hdd_cage_riser(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_SHELF_SPACING, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS);
    }
}

/// UTILITY ///

// the 'cage riser' is a standalone vertical portion of the drive cage, intended to be connected to 'cage riser with rails'.
module draw_hdd_cage_riser(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves, railDims)
{
    difference()
    {
        y = sideMountHoles[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2;
        translate([0, y, 0]) union()
        {
            prv_draw_hdd_cage_shelves(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves);
            prv_draw_hdd_cage_pillars(hddDims);
        }

        prv_draw_hdd_riser_connecting_bolts(sideMountHoles, shelfDims, railDims);
    }
}

// the 'cage riser with rails' is a vertical portion of the drive cage that includes the horizontal rails that connect to the standalone 'cage riser'.
module draw_hdd_cage_riserWithRails(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves, railDims)
{
    difference()
    {
        union()
        {
            y = sideMountHoles[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2;
            translate([0, y, 0]) union()
            {
                prv_draw_hdd_cage_shelves(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves);
                prv_draw_hdd_cage_pillars(hddDims);
            }
            z = RACK_INNER_DIMS[2] - railDims[2];
            for (x = [0, hddDims[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
            {
                translate([x, HDD_CAGE_PILLAR_DIMS[1] + sideMountHoles[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, z]) cube(railDims);
            }
        }

        prv_draw_hdd_riser_connecting_bolts(sideMountHoles, shelfDims, railDims);
    }
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

module prv_draw_hdd(dims, bottomHoles, sideHoles, center)
{
    offset = center ? -dims / 2 : [0, 0, 0];
    difference()
    {
        cube(dims, center);
        translate(offset) draw_hdd_bottom_mounting_holes(bottomHoles);
        translate(offset) draw_hdd_side_mounting_holes(sideHoles);
    }
}

// draw the horizontal shelves of the drive cage
module prv_draw_hdd_cage_shelves(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves)
{
    // middle horizontal shelves
    zOffset = shelfDims[2] + sideMountHoles[1][2];
    for (i = [0 : numShelves - 1])
    {
        z = i * shelfSpacing;
        // shelf
        translate([HDD_CAGE_PILLAR_DIMS[0], 0, z]) cube(shelfDims);
        // mounting nub
        for (x = [HDD_CAGE_PILLAR_DIMS[0], hddDims[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
        {
            translate([x, HDD_CAGE_PILLAR_DIMS[1] / 2, z + zOffset]) sphere(d=HDD_MOUNT_HOLE_DIAMETER * .90, $fn=64);
        }
    }
}

// draw the vertical pillars of the drive cage
module prv_draw_hdd_cage_pillars(hddDims)
{
    // vertical pillars
    for (x = [0, hddDims[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
    {
        difference()
        {
            translate([x, 0, 0]) cube(HDD_CAGE_PILLAR_DIMS);

            translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, -RACK_FLOOR_THICKNESS]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
            translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, 20 + M3x10HeadHeight - RACK_FLOOR_THICKNESS]) rotate([0, 0, 90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
        }
    }
}

// use in a difference, draw the fasteners used to connect the two pieces of the drive cage together.
module prv_draw_hdd_riser_connecting_bolts(sideMountHoles, shelfDims, railDims)
{
    y = sideMountHoles[1][1] + HDD_CAGE_PILLAR_DIMS[1] * 1.5 + railDims[1] + EPSILON;
    z = RACK_INNER_DIMS[2] - railDims[2] / 2;
    for (i = [0 : 1])
    {
        x = ((i + 0.5) * HDD_CAGE_PILLAR_DIMS[0]) + (i * shelfDims[0]);
        translate([x, y, z]) rotate([-90, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
        translate([x, y - 20 - M3x10HeadHeight, z]) rotate([90, -90, 0]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
    }
}
