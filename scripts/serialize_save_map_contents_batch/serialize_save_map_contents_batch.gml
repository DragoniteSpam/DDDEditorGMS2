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