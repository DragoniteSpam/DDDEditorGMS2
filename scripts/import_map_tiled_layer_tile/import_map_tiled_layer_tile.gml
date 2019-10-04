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

var layer_data = json[? "data"];
var layer_name = json[? "name"];
var layer_height = json[? "height"];
var layer_width = json[? "width"];
var layer_alpha = json[? "opacity"];
var layer_visible = json[? "visible"];
var layer_data_x = json[? "x"];
var layer_data_y = json[? "y"];

if (layer_visible) {
	for (var i = 0; i < ds_list_size(layer_data); i++) {
		var tile_x = i div layer_width;
		var tile_y = i mod layer_height;
		var tile_value = layer_data[| i];
		
		if (tile_value) {
			tile_value--;
			var tile_tex_x = tile_value mod columns;
			var tile_tex_y = tile_value div columns;
		}
	}
}

return ++z;