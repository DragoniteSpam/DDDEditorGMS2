function serialize_load_mesh_autotiles(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    array_clear_instances(Game.mesh_autotiles);
    
    var n_mesh_autotiles = buffer_read(buffer, buffer_u32);
    
    repeat (n_mesh_autotiles) {
        var autotile = new DataMeshAutotile("");
        array_push(Game.mesh_autotiles, autotile);
        serialize_load_generic(buffer, autotile, version);
        
        for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
            for (var j = 0; j < AUTOTILE_COUNT; j++) {
                var data = autotile.layers[i].tiles[j];
                var length = buffer_read(buffer, buffer_u32);
                if (length > 0) {
                    var dbuffer = buffer_read_buffer(buffer, length);
                    var vbuffer = vertex_create_buffer_from_buffer(dbuffer, Stuff.graphics.vertex_format);
                    data.Set(dbuffer, vbuffer);
                }
                length = buffer_read(buffer, buffer_u32);
                if (length > 0) {
                    var dbuffer = buffer_read_buffer(buffer, length);
                    var vbuffer = vertex_create_buffer_from_buffer(dbuffer, Stuff.graphics.vertex_format);
                    data.SetReflect(dbuffer, vbuffer);
                }
            }
        }
    }
}