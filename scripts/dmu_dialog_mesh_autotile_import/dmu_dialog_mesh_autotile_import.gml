/// @param UIThing

var thing = argument0;
var map = Stuff.active_map.contents;
var fn = get_open_filename("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", "");

if (!file_exists(fn)) {
    return false;
}

var buffer = buffer_load(fn);
var n = buffer_read(buffer, buffer_u8);

for (var i = 0; i < n; i++) {
    if (map.mesh_autotiles[i]) {
        vertex_delete_buffer(map.mesh_autotiles[i]);
        buffer_delete(map.mesh_autotile_raw[i]);
    }
    
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var len = buffer_read(buffer, buffer_u32);
        map.mesh_autotile_raw[i] = buffer_read_buffer(buffer, len);
        map.mesh_autotiles[i] = vertex_create_buffer_from_buffer(map.mesh_autotile_raw[i], Camera.vertex_format);
    } else {
        map.mesh_autotiles[i] = noone;
        map.mesh_autotiles_raw[i] = noone;
    }
    
    thing.root.buttons[i].color = exists ? c_black : c_gray;
}

buffer_delete(buffer);

return true;