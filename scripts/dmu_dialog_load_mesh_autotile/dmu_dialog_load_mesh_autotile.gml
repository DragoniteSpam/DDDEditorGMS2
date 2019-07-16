/// @param UIThing

var fn = get_open_filename("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "");

if (file_exists(fn)) {
    if (ActiveMap.mesh_autotiles[argument0.key]) {
        vertex_delete_buffer(ActiveMap.mesh_autotiles[argument0.key]);
    }
    
    ActiveMap.mesh_autotiles[argument0.key] = data_import_d3d(fn);
    ActiveMap.mesh_autotile_raw[argument0.key] = buffer_create_from_vertex_buffer(ActiveMap.mesh_autotiles[argument0.key], buffer_fixed, 1);
    vertex_freeze(ActiveMap.mesh_autotiles[argument0.key]);
    
    argument0.color = c_black;
}