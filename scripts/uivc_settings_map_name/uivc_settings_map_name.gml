/// @param UIThing
function uivc_settings_map_name(argument0) {

	var thing = argument0;
	var selection = ui_list_selection(thing.root.el_map_list);

	if (selection >= 0) {
	    var map = Stuff.all_maps[| selection];
	    map.name = thing.value;
	}


}
