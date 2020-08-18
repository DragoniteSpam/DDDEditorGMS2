/// @param MenuElement
function momu_select_all(argument0) {

	var element = argument0;

	selection_clear();

	var selection = instance_create_depth(0, 0, 0, SelectionRectangle);
	ds_list_add(Stuff.map.selection, selection);
	selection.x = 0;
	selection.y = 0;
	selection.z = 0;
	selection.x2 = Stuff.map.active_map.xx;
	selection.y2 = Stuff.map.active_map.yy;
	selection.z2 = Stuff.map.active_map.zz;

	Stuff.map.last_selection = selection;


}
