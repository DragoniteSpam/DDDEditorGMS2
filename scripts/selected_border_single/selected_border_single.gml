/// @param selection
/// @param Entity
function selected_border_single(argument0, argument1) {

	var selection = argument0;
	var entity = argument1;

	var minx = selection.x - 1;
	var miny = selection.y - 1;
	var minz = selection.z - 1;
	var maxx = selection.x + 1;
	var maxy = selection.y + 1;
	var maxz = selection.z + 1;

	return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxz));


}
