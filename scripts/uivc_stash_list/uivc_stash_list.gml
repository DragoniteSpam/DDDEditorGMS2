/// @param UIList
function uivc_stash_list() {

	var list = argument[0];

	if (ds_map_exists(list.root.data, list.key)) {
	    var secondary = list.root.data[? list.key];
	} else {
	    var secondary = ds_map_create();
	    ds_map_add(list.root.data, list.key, secondary);
	}

	// this clears any values already in the map, so if you deselect
	// something it'll be reflected in here as well
	ds_map_copy(secondary, list.selected_entries);


}
