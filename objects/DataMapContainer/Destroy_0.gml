if (contents) {
	instance_activate_object(contents);
	instance_destroy(contents);
}

if (data_buffer) buffer_delete(data_buffer);

ds_list_delete(Stuff.all_maps, ds_list_find_index(Stuff.all_maps, id));