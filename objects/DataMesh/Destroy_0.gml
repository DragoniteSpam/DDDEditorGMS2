if (Stuff.is_quitting) exit;

event_inherited();
var map = Stuff.map.active_map;

ds_list_destroy_instances(submeshes);

for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
    var thing = map.contents.all_entities[| i];
    if (instanceof_classic(thing, EntityMesh) && thing.mesh == GUID) {
        c_world_destroy_object(thing.cobject);
        thing.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
        thing.SetCollisionTransform();
        editor_map_mark_changed(thing);
    }
}

ds_list_delete(Stuff.all_meshes, ds_list_find_index(Stuff.all_meshes, id));