include <global.scad>


for (j = [0 : 3])
{
    z = j * HDD_CAGE_SHELF_SPACING + HDD_CAGE_SHELF_DIMS[2];
    translate([HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X / 2, 0, z]) #draw_hdd_35();
}

draw_hdd_35_cage_riserWithRails();
draw_hdd_35_cage_riser();
//draw_riser_connecting_bolts();

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
        translate(coord) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=32);
    }
}

module draw_hdd_35_side_mounting_holes()
{
    for (coord = HDD_35_SIDE_MOUNT_HOLES)
    {
        translate(coord) rotate([0, 90, 0]) cylinder(h=5, d=HDD_MOUNT_HOLE_DIAMETER, center=true, $fn=32);
    }
}

module draw_hdd_35_cage_shelves()
{
    union()
    {
        // vertical pillars
        for (x = [0, HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
        {
            difference()
            {
                translate([x, 0, 0]) cube(HDD_CAGE_PILLAR_DIMS);
                translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, -RACK_FLOOR_THICKNESS]) rotate([180, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, cld=0.3, $fn=32);
                translate([x + HDD_CAGE_PILLAR_DIMS[0] / 2 , HDD_CAGE_PILLAR_DIMS[0] / 2, 20 + M3x10HeadHeight - RACK_FLOOR_THICKNESS]) rotate([0, 0, 90]) nutcatch_sidecut("M3", clh=0.2, clsl=0.2);
            }
        }
        
        // middle horizontal shelves
        zOffset = HDD_CAGE_SHELF_DIMS[2] + HDD_35_SIDE_MOUNT_HOLES[1][2];
        for (i = [0 : 3])
        {
            z = i * HDD_CAGE_SHELF_SPACING;
            // shelf
            translate([HDD_CAGE_PILLAR_DIMS[0], 0, z]) cube(HDD_CAGE_SHELF_DIMS);
            // mounting nub
            for (x = [HDD_CAGE_PILLAR_DIMS[0], HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
            {
                translate([x, HDD_CAGE_PILLAR_DIMS[1] / 2, z + zOffset]) sphere(d=HDD_MOUNT_HOLE_DIAMETER * .90, $fn=64);
            }
        }
    }
}

module draw_riser_connecting_bolts()
{
    y = HDD_35_SIDE_MOUNT_HOLES[1][1] + HDD_CAGE_PILLAR_DIMS[1] * 1.5 + HDD_CAGE_RAIL_DIMS[1] + EPSILON;
    z = RACK_INNER_DIMS[2] - HDD_CAGE_RAIL_DIMS[2] / 2;
    for (i = [0 : 1])
    {
        x = ((i + 0.5) * HDD_CAGE_PILLAR_DIMS[0]) + (i * HDD_CAGE_SHELF_DIMS[0]);
        translate([x, y, z]) rotate([-90, 0, 0]) hole_through(name="M3",h=M3x10HeadHeight, l=20, $fn=32);
        translate([x, y - 20 - M3x10HeadHeight, z]) rotate([90, -90, 0]) nutcatch_sidecut("M3");
    }
}

module draw_hdd_35_cage_riserWithRails()
{
    difference()
    {
        union()
        {
            y = HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2;
            translate([0, y, 0]) draw_hdd_35_cage_shelves();
            z = RACK_INNER_DIMS[2] - HDD_CAGE_RAIL_DIMS[2];
            for (x = [0, HDD_35_DIMS[0] + HDD_CAGE_PILLAR_DIMS[0] + HDD_CAGE_BUFFER_X])
            {
                translate([x, HDD_CAGE_PILLAR_DIMS[1] + HDD_35_SIDE_MOUNT_HOLES[1][1] - HDD_CAGE_PILLAR_DIMS[1] / 2, z]) cube(HDD_CAGE_RAIL_DIMS);
            }
        }
        draw_riser_connecting_bolts();
    }
}

module draw_hdd_35_cage_riser()
{
    difference()
    {
        y = HDD_35_SIDE_MOUNT_HOLES[0][1] - HDD_CAGE_PILLAR_DIMS[0] / 2;
        translate([0, y, 0]) draw_hdd_35_cage_shelves();
        draw_riser_connecting_bolts();
    }
}
