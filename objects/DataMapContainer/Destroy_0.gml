if (contents) {
	instance_activate_object(contents);
	instance_destroy(contents);
}

if (data_buffer) buffer_delete(data_buffer);
if (preview) buffer_delete(preview);
if (wpreview) buffer_delete(wpreview);
if (cspreview) c_shape_destroy(cspreview);
if (cpreview) c_object_destroy(cpreview);

ds_list_delete(Stuff.all_maps, ds_list_find_index(Stuff.all_maps, id));