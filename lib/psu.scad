include <utility.scad>

// ATX power supply dimensions
ATX_PSU_DIMS = [150, 146, 86];
// ATX power supply mounting hole locations
ATX_PSU_MOUNTING_HOLES = [
    [6, 16],
    [6+114, 6],
    [6, 16+64],
    [6+138, 6+74]
];

module draw_ATX_psu(center=false)
{
    translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
    offset = center ? [0, 0, 0] : -translateToCenter;
    translate(offset) rotate([0,0,180]) difference()
    {
        cube(ATX_PSU_DIMS, center=true);
        translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
    }
    
}

module draw_psu_mounting_holes(holeLocations)
{
    for(coord = holeLocations)
    {
        translate([coord[0], 0, coord[1]]) rotate([90,0,0]) cylinder(h=20, d=2.5, center=true, $fn=64);
    }
}