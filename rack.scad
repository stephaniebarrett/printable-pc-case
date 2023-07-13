RU = 44.5;

RACK_EAR_SIZE = [15.875, 3, 44.5];
RACK_EAR_HOLE_OFFSET = 6.35;
RACK_EAR_HOLE_SPACING = 15.875;

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