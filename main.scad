// 3rd Party
include <Text/alpha.scad>

// Helpers
include <utility.scad>

// PC Components
include <mainboard.scad>
include <psu.scad>
include <hdd.scad>

// Case Components
include <rack.scad>

MB_STANDOFF_SIZE = [5.5, 5.5, 6];
ATX_mb_dims = get_ATX_mainboard_dims();
ATX_psu_dims = get_ATX_psu_dims();
hdd_dims = get_hdd_dims();

MB_POSITION = [0, 0, MB_STANDOFF_SIZE[2]];
PSU_POSITION = [ATX_mb_dims[0] + 10, ATX_mb_dims[1] - ATX_psu_dims[1], 0];

translate(MB_POSITION) draw_ATX_mainboard();
translate(PSU_POSITION) draw_ATX_psu();

for (i = [0 : 7])
{
    x = (i + 1) * hdd_dims[2] + (i * 5);
    translate([x,0,0]) rotate([0,-90,0]) draw_hdd_35();
}


for (i = [0 : 2])
{
    z = i * RACK_EAR_SIZE[2];
    translate([-RACK_EAR_SIZE[0],0,z]) draw_rack_ear();
    translate([450.85,0,z]) draw_rack_ear();
}
cube([450.85, 5, 3 * RU]);
