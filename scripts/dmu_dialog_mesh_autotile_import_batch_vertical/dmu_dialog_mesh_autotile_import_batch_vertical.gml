/// @param UIButton

var button = argument0;
var map = Stuff.map.active_map
var map_contents = map.contents;
var root = filename_dir(get_open_filename_mesh()) + "\\";

for (var i = 0; i < array_length_1d(map_contents.mesh_autotiles_vertical); i++) {
    var fn = root + string(i) + ".d3d";
    
    if (file_exists(fn)) {
        if (map_contents.mesh_autotiles_vertical[i]) {
            vertex_delete_buffer(map_contents.mesh_autotiles_vertical[i]);
            buffer_delete(map_contents.mesh_autotiles_vertical_raw[i]);
        }
        
        var vbuffer = import_d3d(fn, false, true);
        map_contents.mesh_autotiles_vertical[i] = vbuffer;
        
        if (vbuffer) {
            map_contents.mesh_autotiles_vertical_raw[i] = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
            vertex_freeze(vbuffer);
        } else {
            map_contents.mesh_autotiles_vertical_raw[i] = noone;
        }
    }
    
    button.root.buttons[i].color = vbuffer ? c_black : c_gray;
}

return true;