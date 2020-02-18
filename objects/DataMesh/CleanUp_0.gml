if (Stuff.is_quitting) exit;

event_inherited();
var map = Stuff.map.active_map;

for (var i = 0; i < ds_list_size(buffers); i++) {
    buffer_delete(buffers[| i]);
}
for (var i = 0; i < ds_list_size(wbuffers); i++) {
    if (wbuffers[| i])  vertex_delete_buffer(wbuffers[| i]);
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

for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
    var thing = map.contents.all_entities[| i];
    if (instanceof(thing, EntityMesh) && thing.mesh == GUID) {
        c_world_destroy_object(thing.cobject);
        thing.cobject = c_object_create(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
        map_transform_thing(thing);
        editor_map_mark_changed(thing);
    }
}

ds_list_delete(Stuff.all_meshes, ds_list_find_index(Stuff.all_meshes, id));

ds_map_destroy(animations);
ds_grid_destroy(collision_flags);