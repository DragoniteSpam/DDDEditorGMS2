/// @param buffer

var buffer = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_u32, SerializeThings.MAP_BATCH);

buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data)));
buffer_write(buffer, buffer_u64, int64(map_contents.frozen_data_size));
buffer_write_buffer(buffer, map_contents.frozen_data);
buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data_wire)));
buffer_write(buffer, buffer_u64, int64(map_contents.frozen_data_wire_size));
buffer_write_buffer(buffer, map_contents.frozen_data_wire);

for (var i = 0; i < map.xx; i++) {
    for (var j = 0; j < map.yy; j++) {
        for (var k = 0; k < map.zz; k++) {
            buffer_write(buffer, buffer_u64, int64(map_get_tag_grid(i, j, k)));
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

for (var i = ds_map_find_first(exported); i != undefined; i = ds_map_find_next(exported, i)) {
    var vbuffer = exported[? i];
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
ds_map_destroy(exported);
buffer_poke(buffer, addr_count, buffer_u32, count);
buffer_poke(buffer, addr_cache, buffer_u32, buffer_tell(buffer));