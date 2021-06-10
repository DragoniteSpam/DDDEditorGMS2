if (Stuff.is_quitting) exit;

event_inherited();

if (contents) {
    instance_activate_object(contents);
    instance_destroy(contents);
}

buffer_delete(data_buffer);
if (preview) buffer_delete(preview);
if (wpreview) buffer_delete(wpreview);
if (cpreview) c_world_remove_object(cpreview);
if (cpreview) c_object_destroy(cpreview);
if (cspreview) c_shape_destroy(cspreview);

ds_list_delete(Game.maps, ds_list_find_index(Game.maps, id));