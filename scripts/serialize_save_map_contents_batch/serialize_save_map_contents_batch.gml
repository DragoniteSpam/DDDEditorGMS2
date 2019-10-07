/// @param buffer

var buffer = argument0;
var map = Stuff.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_BATCH);

buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data)));
buffer_write_buffer(buffer, map_contents.frozen_data);
buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data_wire)));
buffer_write_buffer(buffer, map_contents.frozen_data_wire);