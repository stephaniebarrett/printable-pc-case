include <global.scad>

draw_ATX_psu();

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

function get_ATX_psu_dims() = ATX_PSU_DIMS;

module draw_psu_mounting_holes(holeLocations)
{
    for(coord = holeLocations)
    {
        translate([coord[0], 0, coord[1]]) rotate([90,0,0]) cylinder(h=20, d=2.5, center=true, $fn=64);
    }
}