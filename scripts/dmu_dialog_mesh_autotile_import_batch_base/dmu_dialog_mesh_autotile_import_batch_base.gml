/// @param UIButton

var button = argument0;
var map = Stuff.map.active_map
var map_contents = map.contents;
var root = filename_dir(get_open_filename_mesh()) + "\\";

for (var i = 0; i < array_length_1d(map_contents.mesh_autotiles); i++) {
    var fn_d3d = root + string(i) + ".d3d";
    var fn_obj = root + string(i) + ".obj";
    
    if (file_exists(fn_d3d) || file_exists(fn_obj)) {
        if (map_contents.mesh_autotiles[i]) {
            vertex_delete_buffer(map_contents.mesh_autotiles[i]);
        }
        map_contents.mesh_autotiles[i] = file_exists(fn_d3d) ? import_d3d(fn_d3d, false, true) : import_obj(fn_d3d, false, true);
        map_contents.mesh_autotile_raw[i] = buffer_create_from_vertex_buffer(map_contents.mesh_autotiles[i], buffer_fixed, 1);
        vertex_freeze(map_contents.mesh_autotiles[i]);
    }
    
    button.root.buttons[i].color = c_black;
}

return true;