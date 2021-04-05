function serialize_load_mesh_autotiles(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    ds_list_clear_disposable(Stuff.all_mesh_autotiles);
    
    var n_mesh_autotiles = buffer_read(buffer, buffer_u32);
    
    repeat (n_mesh_autotiles) {
        var autotile = new DataMeshAutotile("");
        ds_list_add(Stuff.all_mesh_autotiles, autotile);
        serialize_load_generic(buffer, autotile, version);
        
        for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
            for (var j = 0; j < AUTOTILE_COUNT; j++) {
                var data = autotile.layers[i].tiles[j];
                var length = buffer_read(buffer, buffer_u32);
                if (length > 0) {
                    var dbuffer = buffer_read_buffer(buffer, length);
                    if (version < DataVersions.THIRTY_SIX_BYTES) {
                        dbuffer = buffer_from_buffer_legacy(dbuffer);
                    }
                    var vbuffer = vertex_create_buffer_from_buffer(dbuffer, Stuff.graphics.vertex_format);
                    data.Set(dbuffer, vbuffer);
                }
                if (version >= DataVersions.MESH_REFLECTION_DATA) {
                    var length = buffer_read(buffer, buffer_u32);
                    if (length > 0) {
                        var dbuffer = buffer_read_buffer(buffer, length);
                        if (version < DataVersions.THIRTY_SIX_BYTES) {
                            dbuffer = buffer_from_buffer_legacy(dbuffer);
                        }
                        var vbuffer = vertex_create_buffer_from_buffer(dbuffer, Stuff.graphics.vertex_format);
                        data.SetReflect(dbuffer, vbuffer);
                    }
                }
            }
        }
    }
}