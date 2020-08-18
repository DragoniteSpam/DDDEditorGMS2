/// @param UIList
function ui_list_deselect(argument0) {
	// all this does is deselect anything in the list

	var list = argument0;

	ds_map_clear(list.selected_entries);


}
