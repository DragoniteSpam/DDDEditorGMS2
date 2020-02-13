/// @param UIButton

var button = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

var changes = ds_map_create();
for (var i = 0; i < array_length_1d(map_contents.mesh_autotiles_slope); i++) {
    if (map_contents.mesh_autotiles_slope[i]) {
        vertex_delete_buffer(map_contents.mesh_autotiles_slope[i]);
        buffer_delete(map_contents.mesh_autotiles_slope_raw[i]);
        map_contents.mesh_autotiles_slope_raw[i] = noone;
        map_contents.mesh_autotiles_slope[i] = noone;
    }
    changes[? i] = true;
    button.root.buttons[i].color = c_gray;
}

entity_mesh_autotile_check_changes(changes, ATTerrainTypes.SLOPE);

ds_map_destroy(changes);

return true;