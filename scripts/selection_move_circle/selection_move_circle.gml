/// @param SelectionCircle
/// @param dx
/// @param dy
/// @param dz
function selection_move_circle(argument0, argument1, argument2, argument3) {

	var selection = argument0;
	var dx = argument1;
	var dy = argument2;
	var dz = argument3;
	var map = Stuff.map.active_map;

	selection.x = clamp(selection.x + dx, 0, map.xx - 1);
	selection.y = clamp(selection.y + dy, 0, map.yy - 1);
	selection.z = clamp(selection.z + dz, 0, map.zz - 1);


}
