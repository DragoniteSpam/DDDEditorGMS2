/// @param Selection
/// @param x
/// @param y
/// @param z
function sme_down_rectangle(argument0, argument1, argument2, argument3) {

	var selection = argument0;
	var xx = argument1;
	var yy = argument2;
	var zz = argument3;

	selection.x = xx;
	selection.y = yy;
	selection.z = zz;
	selection.x2 = xx;
	selection.y2 = yy;
	selection.z2 = zz + 1;


}
