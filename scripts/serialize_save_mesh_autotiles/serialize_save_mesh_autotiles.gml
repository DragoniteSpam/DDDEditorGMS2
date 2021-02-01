function serialize_save_mesh_autotiles(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.MESH_AUTOTILES);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_mesh_autotile = ds_list_size(Stuff.all_mesh_autotiles);
    buffer_write(buffer, buffer_u32, n_mesh_autotile);
    
    for (var i = 0; i < n_mesh_autotile; i++) {
        var autotile = Stuff.all_mesh_autotiles[| i];
        serialize_save_generic(buffer, autotile);
        
        // it's pretty safe to assume the autotile count won't ever change
        for (var j = 0; j < MeshAutotileLayers.__COUNT; j++) {
            for (var k = 0; k < AUTOTILE_COUNT; k++) {
                var data = autotile.layers[j].tiles[k];
                if (data.buffer) {
                    buffer_write(buffer, buffer_u32, buffer_get_size(data.buffer));
                    buffer_write_buffer(buffer, data.buffer);
                } else {
                    buffer_write(buffer, buffer_u32, 0);
                }
                if (data.reflect_buffer) {
                    buffer_write(buffer, buffer_u32, buffer_get_size(data.reflect_buffer));
                    buffer_write_buffer(buffer, data.reflect_buffer);
                } else {
                    buffer_write(buffer, buffer_u32, 0);
                }
            }
        }
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    return buffer_tell(buffer);
}