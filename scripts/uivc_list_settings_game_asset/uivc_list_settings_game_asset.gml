/// @param UIList
function uivc_list_settings_game_asset(argument0) {
	// this is intended for the asset file list

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var file_data = list.entries[| selection];
	    list.root.el_name.interactive = (selection > 0);
	    list.root.el_compressed.interactive = true;
	    list.root.el_types.interactive = true;
	    list.root.el_critical.interactive = (selection > 0);
	    list.root.el_compressed.value = file_data.compressed;
	    list.root.el_critical.value = file_data.critical;
	    // the first file in the list is special, and its name is just whatever you give it when you save
	    if (selection) {
	        list.root.el_name.interactive = true;
	        ui_input_set_value(list.root.el_name, file_data.internal_name);
	    }
	    // pick out data types that go to this data file
	    ui_list_deselect(list.root.el_types);
	    for (var i = 0; i < array_length(Stuff.game_data_location); i++) {
	        // the first three get special treatment
	        if (i < 3) {
	            if (selection == 0) {
	                ui_list_select(list.root.el_types, i);
	            }
	            continue;
	        }
	        // otherwise, the data belongs in the selected file if its location is set to the file's GUID,
	        // or the file is unassigned and the selected file is the master one
	        if (Stuff.game_data_location[i] == file_data.GUID) {
	            ui_list_select(list.root.el_types, i);
	        } else if (selection == 0 && !guid_get(Stuff.game_data_location[i])) {
	            ui_list_select(list.root.el_types, i);
	        }
	    }
	} else {
	    list.root.el_name.interactive = false;
	    list.root.el_compressed.interactive = false;
	    list.root.el_types.interactive = false;
	    list.root.el_critical.interactive = false;
	}


}
