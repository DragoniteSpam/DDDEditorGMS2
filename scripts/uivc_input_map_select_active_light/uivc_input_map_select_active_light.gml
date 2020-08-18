/// @param UIList
function uivc_input_map_select_active_light(argument0) {

	var active_list = argument0;
	var all_list = active_list.root.el_available_lights;
	var active_selection = ui_list_selection(active_list);
	var all_selection = ui_list_selection(all_list);

	if (active_selection + 1) {
	    ui_list_deselect(all_list);
	    ui_list_select(all_list, ds_list_find_index(all_list.entries, active_list.entries[| active_selection]), true);
	}


}
