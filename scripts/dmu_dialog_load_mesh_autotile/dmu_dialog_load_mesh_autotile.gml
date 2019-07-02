/// @param UIThing

var fn = get_open_filename("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "");

if (file_exists(fn)) {
    if (Stuff.mesh_autotiles[argument0.key] != noone) {
        vertex_delete_buffer(Stuff.mesh_autotiles[argument0.key]);
    }
    
    Stuff.mesh_autotiles[argument0.key] = data_import_d3d(fn);
    argument0.color = c_black;
}