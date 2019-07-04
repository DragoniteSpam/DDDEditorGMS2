/// @param UIThing

var fn = get_save_filename("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", "");

if (fn == "") {
    return false;
}

var buffer = buffer_create(1024, buffer_grow, 1);
buffer_write(buffer, buffer_u8, array_length_1d(ActiveMap.mesh_autotiles));

for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotiles); i++) {
    var exists = ActiveMap.mesh_autotile_raw[i] != noone;
    buffer_write(buffer, buffer_bool, exists);
    if (exists) {
        buffer_write(buffer, buffer_u32, buffer_get_size(ActiveMap.mesh_autotile_raw[i]));
        buffer_write_buffer(buffer, ActiveMap.mesh_autotile_raw[i]);
    }
}

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);

return true;