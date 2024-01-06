EPSILON = 0.01;

function INCH_TO_MM(inch) = inch * 25.4;

function get_rack_height(rackUnits=1) = (rackUnits * 44.45);

module draw_heatset_insert(height, diameter)
{
	cylinder(h=height*1.1, d=diameter, center=false, $fn=32);
}