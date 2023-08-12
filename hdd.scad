include <global.scad>

// EXAMPLE //

// ghost 3.5 HDDs
for (j = [0 : HDD_35_CAGE_NUM_DRIVES - 1])
{
    z = j * HDD_35_CAGE_SHELF_SPACING + HDD_35_CAGE_SHELF_DIMS[2];
    %translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) draw_hdd("hdd");
}

draw_hdd_cage("hdd",true);
draw_hdd_cage("hdd",false);

// ghost 2.5 SSDs
for (j = [0 : HDD_25_CAGE_NUM_DRIVES - 1])
{
    z = j * HDD_25_CAGE_SHELF_SPACING + HDD_25_CAGE_SHELF_DIMS[2];
    %translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) draw_hdd("ssd");
}

draw_hdd_cage("ssd",true);
draw_hdd_cage("ssd",false);


/// PUBLIC ///


function get_hdd_cage_width(type) =
    (type == "ssd") ?
        HDD_CAGE_PILLAR_DIMS[0] * 2 + HDD_25_DIMS[0] + HDD_CAGE_BUFFER_X :
    (type == "hdd") ?
        HDD_CAGE_PILLAR_DIMS[0] * 2 + HDD_35_DIMS[0] + HDD_CAGE_BUFFER_X :
    0;

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
        difference()
        {
            union()
            {
                if (rails)
                {
                    translate([0, HDD_25_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, 0]) draw_hdd_cage_riser(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS);
                    for (x = [0, HDD_25_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
                    {
                        translate([x, HDD_CAGE_PILLAR_DIMS[1] + HDD_25_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, RACK_INNER_DIMS[2] - HDD_25_CAGE_RAIL_DIMS[2]]) cube(HDD_25_CAGE_RAIL_DIMS);
                    }

                }
                else
                {
                    translate([0, HDD_25_SIDE_MOUNT_HOLES[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2, 0]) draw_hdd_cage_riser(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS);
                }
            }
            prv_draw_hdd_riser_connecting_bolts(HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_RAIL_DIMS);
        }
    }
    else if (type == "hdd")
    {
        difference()
        {
            union()
            {
                if (rails)
                {
                    translate([0, HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, 0]) draw_hdd_cage_riser(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_SHELF_SPACING, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS);
                    for (x = [0, HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
                    {
                        translate([x, HDD_CAGE_PILLAR_DIMS[1] + HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, RACK_INNER_DIMS[2] - HDD_35_CAGE_RAIL_DIMS[2]]) cube(HDD_35_CAGE_RAIL_DIMS);
                    }

                }
                else
                {
                    translate([0, HDD_35_SIDE_MOUNT_HOLES[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2, 0]) draw_hdd_cage_riser(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_SHELF_SPACING, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS);
                }
            }
            prv_draw_hdd_riser_connecting_bolts(HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_RAIL_DIMS);
        }
    }
}

/// UTILITY ///

// the 'cage riser' is a standalone vertical portion of the drive cage.
module draw_hdd_cage_riser(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves, railDims)
{
    // middle horizontal shelves
    for (i = [0 : numShelves - 1])
    {
        translate([HDD_CAGE_PILLAR_DIMS[0], 0, i * shelfSpacing]) cube(shelfDims);
    }
    
    difference()
    {
        // vertical pillars
        for (x = [0, hddDims[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
        {
            difference()
            {
                translate([x, 0, 0]) cube(HDD_CAGE_PILLAR_DIMS);

                if (USE_HEATSETS)
                {
                    translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, -RACK_FLOOR_THICKNESS]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=14, cld=THcld, hcld=THhcld, $fn=32);
                    translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, -EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
                }
                else
                {
                    translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, -RACK_FLOOR_THICKNESS]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
                    translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, 20 + M3x10HeadHeight - RACK_FLOOR_THICKNESS]) rotate([0, 0, 90]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
                }
            }
        }
        
        // holes through the pillars to mount drives
        for (i = [0 : numShelves - 1])
        {
            z = i * shelfSpacing + shelfDims[2] + sideMountHoles[1][2];
            translate([0,HDD_CAGE_PILLAR_DIMS[1]/2,z]) rotate([0,-90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
            translate([HDD_CAGE_PILLAR_DIMS[0] * 2 + hddDims[0] + HDD_CAGE_BUFFER_X, HDD_CAGE_PILLAR_DIMS[1] / 2, z]) rotate([0,90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
        }
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

// use in a difference, draw the fasteners used to connect the two pieces of the drive cage together.
module prv_draw_hdd_riser_connecting_bolts(sideMountHoles, shelfDims, railDims)
{
    y = sideMountHoles[1][1] + HDD_CAGE_PILLAR_DIMS[1] * 1.5 + railDims[1] + EPSILON;
    z = RACK_INNER_DIMS[2] - railDims[2] / 2;
    for (i = [0 : 1])
    {
        x = ((i + 0.5) * HDD_CAGE_PILLAR_DIMS[0]) + (i * shelfDims[0]);
        if (USE_HEATSETS)
        {
            translate([x, y, z]) rotate([-90, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=12, cld=THcld, hcld=THhcld, $fn=32);
            translate([x, y - railDims[0], z]) rotate([90, 0, 0]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
        }
        else
        {
            translate([x, y, z]) rotate([-90, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=THcld, hcld=THhcld, $fn=32);
            translate([x, y - 20 - M3x10HeadHeight, z]) rotate([90, -90, 0]) nutcatch_sidecut("M3", clh=NSclh, clsl=NSclsl);
        }
    }
}
