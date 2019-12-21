/// @param UIButton

var button = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

buffer_delete(map_contents.frozen_data);
buffer_delete(map_contents.frozen_data_wire);
map_contents.frozen_data = buffer_create(1, buffer_grow, 1);
map_contents.frozen_data_wire = buffer_create(1, buffer_grow, 1);
map_contents.frozen_data_size = 0;
map_contents.frozen_data_wire_size = 0;

// the vertex buffers are created elsewhere - since they need to be destroyed
// and recreated regardless

// also, clear anonymous collision data

for (var i = 0; i < map.xx; i++) {
    for (var j = 0; j < map.yy; j++) {
        for (var k = 0; k < map.zz; k++) {
            var cell = map_get_grid_cell(i, j, k);
            for (var l = 0; l < array_length_1d(cell); l++) {
                if (is_clamped(cell[@ l], 1000, 2000)) {
                    cell[@ l] = noone;
                }
            }
        }
    }
}

import_map_tiled();

dialog_destroy();