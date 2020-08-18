/// @param terrain
/// @param x
/// @param y
/// @param dir
/// @param average
/// @param dist
function terrain_sub_avg(argument0, argument1, argument2, argument3, argument4, argument5) {

	var terrain = argument0;
	var xx = argument1;
	var yy = argument2;
	var dir = argument3;
	var avg = argument4;
	var dist = argument5;

	terrain_set_z(terrain, xx, yy, lerp(terrain_get_z(terrain, xx, yy), avg, terrain.rate / 20));


}
