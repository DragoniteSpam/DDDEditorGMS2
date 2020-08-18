/// @param UIButton
function dmu_data_remove_map(argument0) {

	var button = argument0;
	var list = button.root.el_map_list;
	var index = ui_list_selection(list);
	var map = Stuff.all_maps[| index];

	if (map == Stuff.map.active_map) {
	    dialog_create_notice(button.root, "Please don't delete a map that you currently have loaded. If you want to delete this map, load a different one first.")
	    return false;
	}

	instance_activate_object(map);
	instance_destroy(map);

	ui_list_deselect(button.root.el_map_list);
	ui_list_select(button.root.el_map_list, ds_list_find_index(Stuff.all_maps, Stuff.map.active_map));


}
