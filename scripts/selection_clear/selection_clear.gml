function selection_clear() {
	for (var i = 0; i < ds_list_size(Stuff.map.selection); i++) {
	    instance_activate_object(Stuff.map.selection[| i]);
	    instance_destroy(Stuff.map.selection[| i]);
	}

	ds_list_clear(Stuff.map.selection);
	Stuff.map.last_selection = noone;

	sa_process_selection();


}
