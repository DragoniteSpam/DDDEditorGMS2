/// @param buffer

var buffer = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_BATCH);

buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data)));
buffer_write(buffer, buffer_u64, int64(map_contents.frozen_data_size));
buffer_write_buffer(buffer, map_contents.frozen_data);
buffer_write(buffer, buffer_u64, int64(buffer_get_size(map_contents.frozen_data_wire)));
buffer_write(buffer, buffer_u64, int64(map_contents.frozen_data_wire_size));
buffer_write_buffer(buffer, map_contents.frozen_data_wire);

var passage_count = 0;
var passage_address = buffer_tell(buffer);
buffer_write(buffer, buffer_u32, 0 /* address */);

for (var i = 0; i < map.xx; i++) {
    for (var j = 0; j < map.yy; j++) {
        for (var k = 0; k < map.zz; k++) {
            var cell = map_get_grid_cell(i, j, k);
            for (var l = 0; l < array_length_1d(cell); l++) {
                if (is_clamped(cell[l], 1000, 2000)) {
                    buffer_write(buffer, buffer_u16, i);
                    buffer_write(buffer, buffer_u16, j);
                    buffer_write(buffer, buffer_u16, k);
                    buffer_write(buffer, buffer_u8, l);
                    buffer_write(buffer, buffer_u16, cell[l] - ANONYMOUS_COLLISION_BASE);
                    passage_count++;
                }
            }
        }
    }
}

buffer_poke(buffer, passage_address, buffer_u32, passage_count);