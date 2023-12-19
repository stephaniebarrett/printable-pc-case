include <global.scad>

// EXAMPLE //

// ghost 3.5 HDDs
x = HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2;
for (j = [0 : HDD_35_CAGE_NUM_DRIVES - 1])
{
    z = j * (HDD_35_CAGE_SHELF_DIMS[2] + HDD_35_DIMS[2] + 1) + HDD_35_DIMS[2] + 0.5;
    %translate([x,0,z]) rotate([0,180,0]) draw_hdd("hdd");
}

draw_hdd_cage("hdd",true);
draw_hdd_cage("hdd",false);

// ghost 2.5 SSDs
translate([200,0,0])
{
    for (j = [0 : HDD_25_CAGE_NUM_DRIVES - 1])
    {
        z = j * HDD_25_CAGE_SHELF_SPACING + HDD_25_CAGE_SHELF_DIMS[2] + HDD_25_CAGE_OFFSET_Z;
        %translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) draw_hdd("ssd");
    }

    draw_hdd_cage("ssd",true);
    draw_hdd_cage("ssd",false);
}

echo(HDD_35_CAGE_SHELF_SPACING);


//draw_hdd_cage_vertical("hdd");

module draw_hdd_cage_vertical(type, numDrives=4)
{
    h = (RACK_INNER_DIMS[2] - HDD_35_DIMS[0]) / 2 - HDD_CAGE_BUFFER_X/2;
    w = (HDD_35_DIMS[2] + HDD_35_CAGE_SHELF_DIMS[1] + HDD_CAGE_BUFFER_X/2) * numDrives + HDD_CAGE_BUFFER_X;
    for (i = [0 : 1])
    {
        y = HDD_35_SIDE_MOUNT_HOLES[i][1]-HDD_35_CAGE_SHELF_DIMS[1]/2;
        // pillars
        for (j = [0, w])
        {
            difference()
            {
                translate([j,y,0]) cube(HDD_CAGE_PILLAR_DIMS);
                translate([HDD_CAGE_PILLAR_DIMS[0]/2+j,y+HDD_CAGE_PILLAR_DIMS[1]/2,-EPSILON]) draw_heatset_insert(M3HEATSET_HEIGHT, M3HEATSET_DIAMETER);
            }
        }

        // bottom shelves
        difference()
        {
            translate([HDD_CAGE_PILLAR_DIMS[0],y,0]) cube([w-HDD_CAGE_PILLAR_DIMS[0],HDD_35_CAGE_SHELF_DIMS[1],h]);
            for (j = [1 : numDrives])
            {
                x = (HDD_35_DIMS[2] + HDD_35_CAGE_SHELF_DIMS[1] + HDD_CAGE_BUFFER_X / 2) * j - HDD_35_SIDE_MOUNT_HOLES[1][2]; 
                translate([x,y+HDD_35_CAGE_SHELF_DIMS[1]/2,0]) rotate([180,0,0]) hole_through(name="M3",h=M3x10HeadHeight, l=14, cld=THcld, hcld=THhcld, $fn=32);
            }
        }

        // top shelves
        difference()
        {
            translate([0,y,HDD_CAGE_PILLAR_DIMS[2]-h]) cube([w,HDD_35_CAGE_SHELF_DIMS[1],h]);
            for (j = [1 : numDrives])
            {
                x = (HDD_35_DIMS[2] + HDD_35_CAGE_SHELF_DIMS[1] + HDD_CAGE_BUFFER_X / 2) * j - HDD_35_SIDE_MOUNT_HOLES[1][2]; 
                translate([x,y+HDD_35_CAGE_SHELF_DIMS[1]/2,HDD_CAGE_PILLAR_DIMS[2]]) hole_through(name="M3",h=M3x10HeadHeight, l=14, cld=THcld, hcld=THhcld, $fn=32);
            }
        }
    }
    {
        // cross members
        y = HDD_35_SIDE_MOUNT_HOLES[1][1];
        dims = [HDD_CAGE_PILLAR_DIMS[0],HDD_35_SIDE_MOUNT_HOLES[0][1]-HDD_35_SIDE_MOUNT_HOLES[1][1],h];
        translate([0,y,HDD_CAGE_PILLAR_DIMS[2]-h]) cube(dims);
        translate([w,y,HDD_CAGE_PILLAR_DIMS[2]-h]) cube(dims);
    }
/*
    // drives
    for (i = [1 : numDrives])
    {
        x = (HDD_35_DIMS[2] + HDD_35_CAGE_SHELF_DIMS[1] + HDD_CAGE_BUFFER_X / 2) * i;
        %translate([x,0,h+HDD_CAGE_BUFFER_X/2]) rotate([0,-90,0]) draw_hdd(type);
    }
*/
}


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
                    translate([0, HDD_25_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, 0]) draw_hdd_cage_riser(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS, HDD_25_CAGE_OFFSET_Z);
                    for (x = [0, HDD_25_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
                    {
                        translate([x, HDD_CAGE_PILLAR_DIMS[1] + HDD_25_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, RACK_INNER_DIMS[2] - HDD_25_CAGE_RAIL_DIMS[2]]) cube(HDD_25_CAGE_RAIL_DIMS);
                    }

                }
                else
                {
                    translate([0, HDD_25_SIDE_MOUNT_HOLES[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2, 0]) draw_hdd_cage_riser(HDD_25_DIMS, HDD_25_SIDE_MOUNT_HOLES, HDD_25_CAGE_SHELF_DIMS, HDD_25_CAGE_SHELF_SPACING, HDD_25_CAGE_NUM_DRIVES, HDD_25_CAGE_RAIL_DIMS, HDD_25_CAGE_OFFSET_Z);
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
                    translate([0, HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, 0]) draw_hdd_cage_riser(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, 28, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS, HDD_35_CAGE_OFFSET_Z, true);
                    for (x = [0, HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
                    {
                        translate([x, HDD_CAGE_PILLAR_DIMS[1] + HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, RACK_INNER_DIMS[2] - HDD_35_CAGE_RAIL_DIMS[2]]) cube(HDD_35_CAGE_RAIL_DIMS);
                    }

                }
                else
                {
                    translate([0, HDD_35_SIDE_MOUNT_HOLES[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2, 0]) draw_hdd_cage_riser(HDD_35_DIMS, HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, 28, HDD_35_CAGE_NUM_DRIVES, HDD_35_CAGE_RAIL_DIMS, HDD_35_CAGE_OFFSET_Z, true);
                }
            }
            prv_draw_hdd_riser_connecting_bolts(HDD_35_SIDE_MOUNT_HOLES, HDD_35_CAGE_SHELF_DIMS, HDD_35_CAGE_RAIL_DIMS);
        }
    }
}

/// UTILITY ///

// the 'cage riser' is a standalone vertical portion of the drive cage.
module draw_hdd_cage_riser(hddDims, sideMountHoles, shelfDims, shelfSpacing, numShelves, railDims, zOffset, flipDrives=false)
{
    // middle horizontal shelves
    if (flipDrives)
    {
        for (i = [0 : numShelves - 2])
            translate([HDD_CAGE_PILLAR_DIMS[0], 0, i * (shelfDims[2] + hddDims[2] + 1.25) + hddDims[2] + 0.5]) cube(shelfDims);
    }
    else
    {
        for (i = [0 : numShelves - 1])
            translate([HDD_CAGE_PILLAR_DIMS[0], 0, i * shelfSpacing + zOffset]) cube(shelfDims);
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
        if (flipDrives)
        {
            for (i = [0 : numShelves - 1])
            {
                z = i * (shelfDims[2] + hddDims[2] + 1) + hddDims[2] - 6;
                translate([0,HDD_CAGE_PILLAR_DIMS[1]/2,z]) rotate([0,-90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
                translate([HDD_CAGE_PILLAR_DIMS[0] * 2 + hddDims[0] + HDD_CAGE_BUFFER_X, HDD_CAGE_PILLAR_DIMS[1] / 2, z]) rotate([0,90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
            }
        }
        else
        {
            for (i = [0 : numShelves - 1])
            {
                z = i * shelfSpacing + shelfDims[2] + sideMountHoles[1][2] + zOffset;
                translate([0,HDD_CAGE_PILLAR_DIMS[1]/2,z]) rotate([0,-90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
                translate([HDD_CAGE_PILLAR_DIMS[0] * 2 + hddDims[0] + HDD_CAGE_BUFFER_X, HDD_CAGE_PILLAR_DIMS[1] / 2, z]) rotate([0,90,0]) hole_through(name="M3",h=M3x10HeadHeight, l=HDD_CAGE_PILLAR_DIMS[1]-M3x10HeadHeight+EPSILON, cld=THcld, hcld=THhcld, $fn=32);
            }
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
