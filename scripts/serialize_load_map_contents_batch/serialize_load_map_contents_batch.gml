/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map = argument2;
var map_contents = map.contents;

buffer_delete(map_contents.frozen_data);
buffer_delete(map_contents.frozen_data_wire);

var length = buffer_read(buffer, buffer_u64);
map_contents.frozen_data_size = buffer_read(buffer, buffer_u64);
map_contents.frozen_data = buffer_read_buffer(buffer, length);

var length = buffer_read(buffer, buffer_u64);
map_contents.frozen_data_wire_size = buffer_read(buffer, buffer_u64);
map_contents.frozen_data_wire = buffer_read_buffer(buffer, length);

if (version >= DataVersions.MAP_FROZEN_TAGS) {
    map_clear_tag_grid(map);
    for (var i = 0; i < map.xx; i++) {
        for (var j = 0; j < map.yy; j++) {
            for (var k = 0; k < map.zz; k++) {
                map_set_tag_grid(i, j, k, buffer_read(buffer, buffer_u64), map);
            }
        }
    }
}

if (buffer_get_size(map_contents.frozen_data) - 1) {
    map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Stuff.graphics.vertex_format);
    vertex_freeze(map_contents.frozen);
}
if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
    map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Stuff.graphics.vertex_format);
    vertex_freeze(map_contents.frozen_wire);
}

if (version >= DataVersions.MAP_STATIC_BATCHES) {
    var skip_to = buffer_read(buffer, buffer_u32);
    buffer_seek(buffer, buffer_seek_start, skip_to);
}