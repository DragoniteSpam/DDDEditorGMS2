/// @param UICheckbox
function uivc_settings_map_3d(argument0) {

	var checkbox = argument0;
	var selection = ui_list_selection(checkbox.root.el_map_list);

	if (selection + 1) {
	    var map = Stuff.all_maps[| selection];
	    map.is_3d = checkbox.value;
	}


}
