/// @param UIButton

var button = argument0;

var filename = get_open_filename("Tiled JSON files (*.json)|*.json", "");
if (file_exists(filename)) {
	var json_buffer = buffer_load(filename);
	var json = json_decode(buffer_read(json_buffer, buffer_text));
	buffer_delete(json_buffer);
	
	var json_type = json[? "type"];
	if (json_type == "map") {
		
		var json_layers = json[? "layers"];
		
		var json_properties = json[? "properties"];
		var map_id = -1;
		
		for (var i = 0; i < ds_list_size(json_properties); i++) {
			var property_name = ds_map_find_value(json_properties[| i], "name");
			var property_type = ds_map_find_value(json_properties[| i], "type");
			var property_value = ds_map_find_value(json_properties[| i], "value");
			
			if (property_name = "id") {
				map_id = property_value;
			}
		}
		
		var json_width = json[? "width"];
		var json_height = json[? "height"];
		
		var json_tilesets = json[? "tilesets"];
		for (var i = 0; i < ds_list_size(json_tilesets); i++) {
			var tileset_data = json_tilesets[| i];
			var tileset_file = tileset_data[? "source"];
		}
		
		var json_layers = json[? "layers"];
		for (var i = 0; i < ds_list_size(json_layers); i++) {
			var layer_data = json_layers[| i];
		}
	}
	
	ds_map_destroy(json);
}