/// @param json
/// @param tileset-columns
/// @param z
/// @param alpha
/// @param x
/// @param y

var json = argument[0];
var columns = argument[1];
var z = argument[2];
var alpha = (argument_count > 3) ? argument[3] : 1;
var xx = (argument_count > 4) ? argument[4] : 0;
var yy = (argument_count > 5) ? argument[5] : 0;
var map = Stuff.active_map;
var map_contents = map.contents;
var ts = get_active_tileset();

var layer_data = json[? "data"];
var layer_name = json[? "name"];
var layer_height = json[? "height"];
var layer_width = json[? "width"];
var layer_alpha = json[? "opacity"];
var layer_visible = json[? "visible"];
var layer_data_x = json[? "x"];
var layer_data_y = json[? "y"];

var layer_base_z = get_2D_base_layer(z);;

if (layer_visible) {
	for (var i = 0; i < ds_list_size(layer_data); i++) {
		var tile_x = i mod layer_width;
		var tile_y = i div layer_height;
		var tile_value = layer_data[| i];
        
		if (tile_value) {
			tile_value--;
			var tile_tex_x = tile_value mod columns;
			var tile_tex_y = tile_value div columns;
            
			if (is_clamped(tile_x, 0, Stuff.active_map.xx - 1) && is_clamped(tile_y, 0, Stuff.active_map.yy - 1) && is_clamped(z, 0, Stuff.active_map.zz - 1)) {
				batch_tile_raw(map_contents.frozen_data, map_contents.frozen_data_wire, tile_x, tile_y, z, tile_tex_x, tile_tex_y, c_white, layer_alpha);
                // the solidness is applied to each of the layers; entities will most likely only exist on Layer 1, but solidness will be applied to any
                for (var j = 0; j < TILED_MAP_LAYERS_PER_BASE_LAYER; j++) {
                    map_add_thing_anonymous(ts.passage[# tile_tex_x, tile_tex_y], tile_x, tile_y, layer_base_z + j, map, MapCellContents.TILE);
                }
			}
		}
	}
}

return ++z;