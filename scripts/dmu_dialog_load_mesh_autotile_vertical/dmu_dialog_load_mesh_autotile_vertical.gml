/// @param UIThing
function dmu_dialog_load_mesh_autotile_vertical(argument0) {

	var thing = argument0;

	var fn = get_open_filename_mesh_d3d();

	if (file_exists(fn)) {
	    var map = Stuff.map.active_map;
	    var map_contents = map.contents;
	    if (map_contents.mesh_autotiles_vertical[thing.key]) {
	        vertex_delete_buffer(map_contents.mesh_autotiles_vertical[thing.key]);
	        buffer_delete(map_contents.mesh_autotiles_vertical_raw[thing.key]);
	    }
    
	    var vbuffer = import_d3d(fn, false);
	    map_contents.mesh_autotiles_vertical[thing.key] = vbuffer;
    
	    if (vbuffer) {
	        map_contents.mesh_autotiles_vertical_raw[thing.key] = buffer_create_from_vertex_buffer(map_contents.mesh_autotiles_vertical[thing.key], buffer_fixed, 1);
	        vertex_freeze(map_contents.mesh_autotiles_vertical[thing.key]);
	    } else {
	        map_contents.mesh_autotiles_vertical_raw[thing.key] = noone;
	    }
    
	    thing.color = vbuffer ? c_black : c_gray;
    
	    var changes = ds_map_create();
	    changes[? thing.key] = true;
	    entity_mesh_autotile_check_changes(changes, ATTerrainTypes.VERTICAL);
	    ds_map_destroy(changes);
	}


}
