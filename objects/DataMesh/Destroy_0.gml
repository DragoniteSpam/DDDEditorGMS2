event_inherited();

if (buffer_exists(buffer)) buffer_delete(buffer);
if (vbuffer) vertex_delete_buffer(vbuffer);
if (wbuffer) vertex_delete_buffer(wbuffer);
if (cshape) c_shape_destroy(cshape);

ds_list_delete(Stuff.all_meshes, ds_list_find_index(Stuff.all_meshes, id));