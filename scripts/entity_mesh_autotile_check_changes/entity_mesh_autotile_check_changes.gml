function entity_mesh_autotile_check_changes(changes) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
        var thing = map_contents.all_entities[| i];
        if (thing.etype == ETypes.ENTITY_MESH_AUTO && changes[$ thing.AutotileUniqueIdentifier()]) {
            editor_map_mark_changed(thing);
        }
    }
}