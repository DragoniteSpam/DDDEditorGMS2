/// @param selection
/// @param Entity
function selected_single(argument0, argument1) {

	var selection = argument0;
	var entity = argument1;

	return (selection.x == entity.xx && selection.y == entity.yy) && (!Stuff.map.active_map.is_3d || selection.z == entity.zz);


}
