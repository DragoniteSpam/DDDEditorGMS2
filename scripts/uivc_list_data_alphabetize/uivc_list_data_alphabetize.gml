/// @param UIList
function uivc_list_data_alphabetize(argument0) {

	var list = argument0;

	// put the enums at the top
	var list_data = ds_list_create();
	var list_enums = ds_list_create();
	for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
	    var data = Stuff.all_data[| i];
	    if (data.type == DataTypes.ENUM) {
	        ds_list_add(list_enums, data);
	    } else {
	        ds_list_add(list_data, data);
	    }
	}

	// Normally you'd just use the list sort funciton on the source lists since they
	// don't modify them, but in this case we want the enums to always go at the top
	var list_enums_sorted = ds_list_sort_name(list_enums);
	var list_data_sorted = ds_list_sort_name(list_data);
	ds_list_clear(Stuff.all_data);
	for (var i = 0; i < ds_list_size(list_enums_sorted); i++) {
	    ds_list_add(Stuff.all_data, list_enums_sorted[| i]);
	}
	for (var i = 0; i < ds_list_size(list_data_sorted); i++) {
	    ds_list_add(Stuff.all_data, list_data_sorted[| i]);
	}
	ds_list_destroy(list_data);
	ds_list_destroy(list_enums);
	ds_list_destroy(list_data_sorted);
	ds_list_destroy(list_enums_sorted);

	var selection = ui_list_selection(list);

	if (selection + 1) {
	    ui_list_deselect(list);
	    ui_list_select(list, ds_list_find_index(Stuff.all_data, list.root.selected_data), true);
	}


}
