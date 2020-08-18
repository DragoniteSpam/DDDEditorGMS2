/// @param list
function ds_list_clear_instances(argument0) {
	// this was implemented some time into the project. there are probably
	// a couple destroy events that could use this but don't.

	var list = argument0;
	var n = ds_list_size(list);

	for (var i = 0; i < n; i++) {
	    var what = list[| i];
	    if (what) {
	        instance_activate_object(list[| i]);
	        instance_destroy(list[| i]);
	    }
	}

	ds_list_clear(list);

	return n;


}
