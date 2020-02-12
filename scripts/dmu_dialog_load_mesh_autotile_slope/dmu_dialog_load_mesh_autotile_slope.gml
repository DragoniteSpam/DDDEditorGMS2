/// @param UIThing

var thing = argument0;

var fn = get_open_filename_mesh_d3d();

if (file_exists(fn)) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    if (map_contents.mesh_autotiles_slope[thing.key]) {
        vertex_delete_buffer(map_contents.mesh_autotiles_slope[thing.key]);
        buffer_delete(map_contents.mesh_autotile_slope_raw[thing.key]);
    }
    
    var vbuffer = import_d3d(fn, false, true);
    map_contents.mesh_autotiles_slope[thing.key] = vbuffer;
    
    if (vbuffer) {
        map_contents.mesh_autotile_slope_raw[thing.key] = buffer_create_from_vertex_buffer(map_contents.mesh_autotiles_slope[thing.key], buffer_fixed, 1);
        vertex_freeze(map_contents.mesh_autotiles_slope[thing.key]);
    } else {
        map_contents.mesh_autotile_slope_raw[thing.key] = noone;
    }
    
    thing.color = vbuffer ? c_black : c_gray;
}