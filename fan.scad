include <global.scad>

// TODO: support other fan sizes and depths
function get_fan_spacing(size) =
    (size == 120) ?
        105 :
    (size == 92) ?
        82.5 :
    (size == 80) ?
        71.5 :
    (size == 70) ?
        60 :
    (size == 60) ?
        50 :
    (size == 50) ?
        40 :
    (size == 40) ?
        32 :
    0;
             

module draw_fan(diameter, size, depth)
{
    difference()
    {
        cube([size, depth, size]);
        draw_fan_mounting_holes(size, depth);
        draw_fan_through_hole(diameter, size, depth);
    }
}

module draw_fan_mounting_holes(size, depth)
{
    spacing = get_fan_spacing(size);
    offset = (size-spacing)/2;
    
    translate([offset, (depth+2)/2-1, offset]) rotate([90,0,0]) cylinder(h=depth+2,d=FAN_MOUNTING_HOLE_DIAMETER,center=true, $fn=32);
    translate([offset+spacing, (depth+2)/2-1, offset]) rotate([90,0,0]) cylinder(h=depth+2,d=FAN_MOUNTING_HOLE_DIAMETER,center=true, $fn=32);
    translate([offset, (depth+2)/2-1, offset+spacing]) rotate([90,0,0]) cylinder(h=depth+2,d=FAN_MOUNTING_HOLE_DIAMETER,center=true, $fn=32);
    translate([offset+spacing, (depth+2)/2-1, offset+spacing]) rotate([90,0,0]) cylinder(h=depth+2,d=FAN_MOUNTING_HOLE_DIAMETER,center=true, $fn=32);
}

module draw_fan_through_hole(diameter, size, depth)
{
    translate([size/2,(depth+2)/2-1,size/2]) rotate([90,0,0]) cylinder(h=depth+2,d=diameter,center=true, $fn=32);
}