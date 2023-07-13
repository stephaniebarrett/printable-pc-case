include <utility.scad>

//RU = 44.5;
RACK_EAR_SIZE = [15.875, 5, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;
RACK_WALL_THICKNESS = 5;
RACK_FLOOR_THICKNESS = 5;
RACK_ROOF_THICKNESS = 3;
RACK_WIDTH = 450.85;

function get_rack_height(rackUnits=1) = (rackUnits * 44.5);
function get_rack_outer_dims(rackUnits, depth) = [RACK_WIDTH, depth, get_rack_height(rackUnits)];
function get_rack_inner_dims(rackUnits, depth) = [RACK_WIDTH - RACK_WALL_THICKNESS * 2, depth, get_rack_height(rackUnits) - RACK_FLOOR_THICKNESS - RACK_ROOF_THICKNESS];
function get_rack_wall_thickness() = RACK_WALL_THICKNESS;
function get_rack_floor_thickness() = RACK_FLOOR_THICKNESS;
function get_rack_roof_thickness() = RACK_ROOF_THICKNESS;

module draw_rack_ear()
{
    //TODO: support circular holes
    difference()
    {
        cube(RACK_EAR_SIZE);
        for (i = [0 : 2])
        {
            z = i * RACK_EAR_HOLE_SPACING + RACK_EAR_HOLE_OFFSET;
            translate([RACK_EAR_SIZE[0]/2, RACK_EAR_SIZE[1]/2, z]) cube(9.4, center=true);
        }
    }
}

module draw_rack_enclosure(rackUnits, depth)
{
    difference()
    {
        cube(get_rack_outer_dims(rackUnits, depth));
        innerDims = get_rack_inner_dims(rackUnits, depth);
        innerDimsEpsilon = [innerDims[0], innerDims[1] + EPSILON * 2, innerDims[2]];
        translate([RACK_WALL_THICKNESS, -EPSILON, RACK_FLOOR_THICKNESS]) cube(innerDimsEpsilon);
    }
}

