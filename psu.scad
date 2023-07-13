include <Text/alpha.scad>

ATX_PSU_DIMS = [150, 146, 86];

ATX_PSU_MOUNTING_HOLES = [
    [6, 16],
    [6+114, 6],
    [6, 16+64],
    [6+138, 6+74]
];

module psuDemo()
{
    draw_atx_psu();
}

module draw_atx_psu(center=false)
{
    translateToCenter = [-ATX_PSU_DIMS[0]/2, -ATX_PSU_DIMS[1]/2, -ATX_PSU_DIMS[2]/2];
    offset = center ? [0, 0, 0] : -translateToCenter;
    translate(offset) rotate([0,0,180]) difference()
    {
        cube(ATX_PSU_DIMS, center=true);
        translate(translateToCenter) draw_psu_mounting_holes(ATX_PSU_MOUNTING_HOLES);
        translate(translateToCenter) draw_psu_type_label("ATX PSU", ATX_PSU_DIMS);
    }
    
}

module draw_psu_mounting_holes(holeLocations)
{
    for(coord = holeLocations)
    {
        translate([coord[0], 0, coord[1]]) rotate([90,0,0]) cylinder(h=10, d=2.5, center=true, $fn=64);
    }
}

module draw_psu_type_label(label, psuDims)
{
    translate([psuDims[0]/2+getwid(label)/2, psuDims[1]/2, psuDims[2]-.99]) alpha_draw_string(0, 0, 180, label, $type="square", $cross=bold);
}