/// @param changes[?]
/// @param type
function entity_mesh_autotile_check_changes(argument0, argument1) {

    var changes = argument0;
    var type = argument1;
    var map = Stuff.map.active_map;
    var map_contents = map.contents;

    for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
        var thing = map_contents.all_entities[| i];
        if (instanceof_classic(thing, EntityMeshAutotile)) {
            if (thing.terrain_type = type && changes[? thing.terrain_id]) {
                editor_map_mark_changed(thing);
            }
        }
    }


}
