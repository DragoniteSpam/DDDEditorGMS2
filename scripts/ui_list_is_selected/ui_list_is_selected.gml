/// @param UIList
/// @param value
function ui_list_is_selected(argument0, argument1) {

	var list = argument0;
	var key = argument1;

	return ds_map_exists(list.selected_entries, key);


}
