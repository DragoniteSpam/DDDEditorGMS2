function serialize_load_map_contents_batch(buffer, version, map) {
    var map_contents = map.contents;
    
    if (version >= DataVersions.MAP_SKIP_ADDRESSES) {
        var skip_addr = buffer_read(buffer, buffer_u64);
    }
    
    if (map_contents.frozen_data) buffer_delete(map_contents.frozen_data);
    if (map_contents.frozen_data_wire) buffer_delete(map_contents.frozen_data_wire);
    if (map_contents.reflect_frozen_data) buffer_delete(map_contents.reflect_frozen_data);
    if (map_contents.reflect_frozen_data_wire) buffer_delete(map_contents.reflect_frozen_data_wire);
    
    map_contents.frozen_data = undefined;
    map_contents.frozen_data_wire = undefined;
    map_contents.reflect_frozen_data = undefined;
    map_contents.reflect_frozen_data_wire = undefined;
    
    var length = buffer_read(buffer, buffer_u64);
    if (version >= DataVersions.MESH_REFLECTION_DATA) {
    } else {
        buffer_read(buffer, buffer_u64);            // no longer needed
    }
    if (length > 0) map_contents.frozen_data = buffer_read_buffer(buffer, length);
    
    var length = buffer_read(buffer, buffer_u64);
    if (version >= DataVersions.MESH_REFLECTION_DATA) {
    } else {
        buffer_read(buffer, buffer_u64);            // no longer needed
    }
    if (length > 0) map_contents.frozen_data_wire = buffer_read_buffer(buffer, length);
    
    if (version >= DataVersions.MESH_REFLECTION_DATA) {
        var length = buffer_read(buffer, buffer_u64);
        if (length > 0) map_contents.reflect_frozen_data = buffer_read_buffer(buffer, length);
        
        var length = buffer_read(buffer, buffer_u64);
        if (length > 0) map_contents.reflect_frozen_data_wire = buffer_read_buffer(buffer, length);
    }
    
    if (version >= DataVersions.MAP_FROZEN_TAGS) {
        for (var i = 0; i < map.xx; i++) {
            for (var j = 0; j < map.yy; j++) {
                for (var k = 0; k < map.zz; k++) {
                    map.SetFlag(i, j, k, buffer_read(buffer, buffer_flag));
                }
            }
        }
    }
    
    if (map_contents.frozen_data && buffer_get_size(map_contents.frozen_data) > 0) {
        if (version < DataVersions.THIRTY_SIX_BYTES) {
            map_contents.frozen_data = buffer_from_buffer_legacy(map_contents.frozen_data);
        }
        map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.frozen);
    }
    
    if (map_contents.frozen_data_wire && buffer_get_size(map_contents.frozen_data_wire) > 0) {
        if (version < DataVersions.THIRTY_SIX_BYTES) {
            map_contents.frozen_data_wire = buffer_from_buffer_legacy(map_contents.frozen_data_wire);
        }
        map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.frozen_wire);
    }
    
    if (map_contents.reflect_frozen_data && buffer_get_size(map_contents.reflect_frozen_data) > 0) {
        if (version < DataVersions.THIRTY_SIX_BYTES) {
            map_contents.reflect_frozen_data = buffer_from_buffer_legacy(map_contents.reflect_frozen_data);
        }
        map_contents.reflect_frozen = vertex_create_buffer_from_buffer(map_contents.reflect_frozen_data, Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.reflect_frozen);
    }
    
    if (map_contents.reflect_frozen_data_wire && buffer_get_size(map_contents.reflect_frozen_data_wire) > 0) {
        if (version < DataVersions.THIRTY_SIX_BYTES) {
            map_contents.reflect_frozen_data_wire = buffer_from_buffer_legacy(map_contents.reflect_frozen_data_wire);
        }
        map_contents.reflect_frozen_wire = vertex_create_buffer_from_buffer(map_contents.reflect_frozen_data_wire, Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.reflect_frozen_wire);
    }
    
    if (version >= DataVersions.MAP_STATIC_BATCHES) {
        var skip_to = buffer_read(buffer, buffer_u32);
        buffer_seek(buffer, buffer_seek_start, skip_to);
    }
}