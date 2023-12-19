module draw_heatset_insert(height, diameter)
{
	cylinder(h=height*1.1, d=M3HEATSET_DIAMETER, center=false, $fn=32);
}