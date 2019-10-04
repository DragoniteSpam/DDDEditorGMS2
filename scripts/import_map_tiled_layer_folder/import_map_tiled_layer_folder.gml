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

var group_layers = json[? "layers"];		//
var group_name = json[? "name"];
var group_alpha = json[? "opacity"];		//
var group_visible = json[? "visible"];		//
var group_x = json[? "x"];					//
var group_y = json[? "y"];					//

if (group_visible) {
	for (var i = 0; i < ds_list_size(group_layers); i++) {
		var layer_data = group_layers[| i];
		var layer_type = layer_data[? "type"];
			
		switch (layer_type) {
			case "group": import_map_tiled_layer_folder(layer_data, columns, alpha * group_alpha, xx, yy); break;
			case "objectgroup": import_map_tiled_layer_object(layer_data, columns, alpha * group_alpha, xx, yy); break;
			case "tilelayer": import_map_tiled_layer_tile(layer_data, columns, alpha * group_alpha, xx, yy); break;
		}
	}
}

return z;