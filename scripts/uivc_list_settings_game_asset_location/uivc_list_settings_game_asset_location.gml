/// @param UIList
function uivc_list_settings_game_asset_location(argument0) {
	// this is intended for the game data type list

	var list = argument0;
	var list_main = list.root.el_list;
	var selection_main = ui_list_selection(list_main);

	if (selection_main + 1) {
	    var file_data = list_main.entries[| selection_main];
	    for (var i = 0; i < ds_list_size(list.entries); i++) {
	        // the first three types will always be in the main data file, and will never be moved
	        if (i < 3) {
	            if (selection_main == 0) {
	                ui_list_select(list, i);
	            } else {
	                ds_map_delete(list.selected_entries, i);
	            }
	            continue;
	        }
	        // otherwise, if a thing is selected, assign it
	        if (ui_list_is_selected(list, i)) {
	            Stuff.game_data_location[i] = file_data.GUID;
	        }
	    }
	}


}
