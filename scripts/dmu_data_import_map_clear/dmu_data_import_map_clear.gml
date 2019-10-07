/// @param UIButton

var button = argument0;
var map = Stuff.active_map;
var map_contents = map.contents;

buffer_delete(map_contents.frozen_data);
buffer_delete(map_contents.frozen_data_wire);
map_contents.frozen_data = buffer_create(1, buffer_grow, 1);
map_contents.frozen_data_wire = buffer_create(1, buffer_grow, 1);

// the vertex buffers are created elsewhere - since they need to be destroyed
// and recreated regardless

import_map_tiled();

dialog_destroy();