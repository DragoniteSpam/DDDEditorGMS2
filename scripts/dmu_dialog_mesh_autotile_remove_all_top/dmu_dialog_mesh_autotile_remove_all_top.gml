/// @param UIButton
function dmu_dialog_mesh_autotile_remove_all_top(argument0) {

    var button = argument0;
    var map = Stuff.map.active_map;
    var map_contents = map.contents;

    var changes = ds_map_create();
    for (var i = 0; i < array_length(map_contents.mesh_autotiles_top); i++) {
        if (map_contents.mesh_autotiles_top[i]) {
            vertex_delete_buffer(map_contents.mesh_autotiles_top[i]);
            buffer_delete(map_contents.mesh_autotiles_top_raw[i]);
            map_contents.mesh_autotiles_top_raw[i] = noone;
            map_contents.mesh_autotiles_top[i] = noone;
        }
        changes[? i] = true;
        button.root.buttons[i].color = c_gray;
    }

    entity_mesh_autotile_check_changes(changes, ATTerrainTypes.TOP);

    ds_map_destroy(changes);

    return true;


}
