/// @param UIThing

var thing = argument0;

var fn = get_open_filename_mesh_d3d();

if (file_exists(fn)) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    if (map_contents.mesh_autotiles[thing.key]) {
        vertex_delete_buffer(map_contents.mesh_autotiles[thing.key]);
    }
    
    map_contents.mesh_autotiles[thing.key] = data_import_d3d(fn);
    map_contents.mesh_autotile_raw[thing.key] = buffer_create_from_vertex_buffer(map_contents.mesh_autotiles[thing.key], buffer_fixed, 1);
    vertex_freeze(map_contents.mesh_autotiles[thing.key]);
    
    thing.color = c_black;
}