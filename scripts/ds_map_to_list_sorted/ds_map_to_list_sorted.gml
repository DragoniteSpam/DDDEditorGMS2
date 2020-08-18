/// @param map
function ds_map_to_list_sorted(argument0) {

	var map = argument0;
	var list = ds_list_create();

	if (ds_map_empty(map)) {
	    return list;
	}

	var q = ds_priority_create();
	var thing = ds_map_find_first(map);

	while (ds_map_find_last(map) != thing) {
	    ds_priority_add(q, thing, thing);
	    thing = ds_map_find_next(map, thing);
	}

	ds_priority_add(q, thing, thing);

	while (!ds_priority_empty(q)) {
	    ds_list_add(list, ds_priority_delete_min(q));
	}

	ds_priority_destroy(q);

	return list;


}
