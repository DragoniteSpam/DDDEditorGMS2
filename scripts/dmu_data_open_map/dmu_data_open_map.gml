/// @param UIButton
function dmu_data_open_map(argument0) {

	var button = argument0;
	var list = button.root.el_map_list;
	var index = ui_list_selection(list);
	var map = Stuff.all_maps[| index];

	if (map != Stuff.map.active_map) {
	    selection_clear();
	    load_a_map(map);
	}


}
