/// @param UIButton
function dmu_dialog_mesh_autotile_remove_all_vertical(argument0) {

	var button = argument0;
	var map = Stuff.map.active_map;
	var map_contents = map.contents;

	var changes = ds_map_create();
	for (var i = 0; i < array_length(map_contents.mesh_autotiles_vertical); i++) {
	    if (map_contents.mesh_autotiles_vertical[i]) {
	        vertex_delete_buffer(map_contents.mesh_autotiles_vertical[i]);
	        buffer_delete(map_contents.mesh_autotiles_vertical_raw[i]);
	        map_contents.mesh_autotiles_vertical_raw[i] = noone;
	        map_contents.mesh_autotiles_vertical[i] = noone;
	    }
	    changes[? i] = true;
	    button.root.buttons[i].color = c_gray;
	}

	entity_mesh_autotile_check_changes(changes, ATTerrainTypes.VERTICAL);

	ds_map_destroy(changes);

	return true;


}
