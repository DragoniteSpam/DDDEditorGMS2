function serialize_save_map_contents_batch(buffer) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    buffer_write(buffer, buffer_u32, SerializeThings.MAP_BATCH);
    var addr_skip = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_u64, buffer_get_size(map_contents.frozen_data));
    buffer_write_buffer(buffer, map_contents.frozen_data);
    buffer_write(buffer, buffer_u64, buffer_get_size(map_contents.frozen_data_wire));
    buffer_write_buffer(buffer, map_contents.frozen_data_wire);
    
    if (map_contents.reflect_frozen_data) {
        buffer_write(buffer, buffer_u64, buffer_get_size(map_contents.reflect_frozen_data));
        buffer_write_buffer(buffer, map_contents.reflect_frozen_data);
        buffer_write(buffer, buffer_u64, buffer_get_size(map_contents.reflect_frozen_data_wire));
        buffer_write_buffer(buffer, map_contents.reflect_frozen_data_wire);
    } else {
        buffer_write(buffer, buffer_u64, 0);
        buffer_write(buffer, buffer_u64, 0);
    }
    
    for (var i = 0; i < map.xx; i++) {
        for (var j = 0; j < map.yy; j++) {
            for (var k = 0; k < map.zz; k++) {
                buffer_write(buffer, buffer_flag, int64(map.GetFlag(i, j, k)));
            }
        }
    }
    
    var addr_cache = buffer_tell(buffer);
    buffer_write(buffer, buffer_u32, 0);
    // if this goes well, make it a game setting
    var chunk_size = 32;
    var exported = batch_all_export(map, chunk_size);
    
    var addr_count = buffer_tell(buffer);
    var count = 0;
    buffer_write(buffer, buffer_u32, 0);
    buffer_write(buffer, buffer_u32, chunk_size);
    
    for (var i = 0; i < array_length(exported); i++) {
        var vbuffer = exported[i];
        if (vertex_get_number(vbuffer) > 0) {
            buffer_write(buffer, buffer_u16, i >> 24);
            buffer_write(buffer, buffer_u16, i & 0xffffff);
            var chunk = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
            buffer_write(buffer, buffer_u32, buffer_get_size(chunk));
            buffer_write_buffer(buffer, chunk);
            buffer_delete(chunk);
        }
        vertex_delete_buffer(vbuffer);
        count++;
    }
    
    buffer_poke(buffer, addr_count, buffer_u32, count);
    buffer_poke(buffer, addr_cache, buffer_u32, buffer_tell(buffer));
    buffer_poke(buffer, addr_skip, buffer_u64, buffer_tell(buffer));
}