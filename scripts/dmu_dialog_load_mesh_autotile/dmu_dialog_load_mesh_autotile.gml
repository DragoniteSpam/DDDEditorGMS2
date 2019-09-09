/// @param UIThing

var thing = argument0;

var fn = get_open_filename("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "");

if (file_exists(fn)) {
	var map = Stuff.active_map;
    if (map.mesh_autotiles[thing.key]) {
        vertex_delete_buffer(map.mesh_autotiles[thing.key]);
    }
    
    map.mesh_autotiles[thing.key] = data_import_d3d(fn);
    map.mesh_autotile_raw[thing.key] = buffer_create_from_vertex_buffer(map.mesh_autotiles[thing.key], buffer_fixed, 1);
    vertex_freeze(map.mesh_autotiles[thing.key]);
    
    thing.color = c_black;
}