if (contents) {
	instance_activate_object(contents);
	instance_destroy(contents);
}

if (data_buffer) buffer_delete(data_buffer);
if (preview) buffer_delete(preview);
if (wpreview) buffer_delete(wpreview);
if (cpreview) c_world_destroy_object(cpreview);
if (cspreview) c_shape_destroy(cspreview);

ds_list_delete(Stuff.all_maps, ds_list_find_index(Stuff.all_maps, id));