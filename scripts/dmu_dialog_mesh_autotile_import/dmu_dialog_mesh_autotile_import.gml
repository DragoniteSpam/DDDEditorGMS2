/// @param UIThing

var fn = get_open_filename("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", "");

if (!file_exists(fn)) {
    return false;
}

var buffer = buffer_load(fn);
var n = buffer_read(buffer, buffer_u8);

for (var i = 0; i < n; i++) {
    if (ActiveMap.mesh_autotiles[i]) {
        vertex_delete_buffer(ActiveMap.mesh_autotiles[i]);
        buffer_delete(ActiveMap.mesh_autotile_raw[i]);
    }
    
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var len = buffer_read(buffer, buffer_u32);
        ActiveMap.mesh_autotile_raw[i] = buffer_read_buffer(buffer, len);
        ActiveMap.mesh_autotiles[i] = vertex_create_buffer_from_buffer(ActiveMap.mesh_autotile_raw[i], Camera.vertex_format);
    } else {
        ActiveMap.mesh_autotiles[i] = noone;
        ActiveMap.mesh_autotiles_raw[i] = noone;
    }
    
    argument0.root.buttons[i].color = exists ? c_black : c_gray;
}

buffer_delete(buffer);

return true;