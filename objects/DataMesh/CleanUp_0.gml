if (Stuff.is_quitting) exit;

event_inherited();

for (var i = 0; i < ds_list_size(buffers); i++) {
    buffer_delete(buffers[| i]);
}
for (var i = 0; i < ds_list_size(wbuffers); i++) {
    if (wbuffers[| i])  buffer_delete(wbuffers[| i]);
}
ds_list_destroy(wbuffers);
if (cshape) c_shape_destroy(cshape);
switch (type) {
    case MeshTypes.RAW:
        for (var i = 0; i < ds_list_size(vbuffers); i++) {
            if (vbuffers[| i])  vertex_delete_buffer(vbuffers[| i]);
        }
        break;
    case MeshTypes.SMF:
        for (var i = 0; i < ds_list_size(vbuffers); i++) {
            if (vbuffers[| i])  smf_model_destroy(vbuffers[| i]);
        }
        break;
}
ds_list_destroy(vbuffers);

show_debug_message("Deleting a mesh will cause anything that uses this mesh's collision shape to immediately crash; at some point you should probably take care of that");

ds_list_delete(Stuff.all_meshes, ds_list_find_index(Stuff.all_meshes, id));

ds_map_destroy(animations);
ds_grid_destroy(collision_flags);