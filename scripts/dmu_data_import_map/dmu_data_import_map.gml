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
		
		var json_width = json[? "width"];
		var json_height = json[? "height"];
		
		var json_tilesets = json[? "tilesets"];
		for (var i = 0; i < ds_list_size(json_tilesets); i++) {
			var tileset_data = json_tilesets[| i];
			var tileset_file = tileset_data[? "source"];
			
			debug(tileset_file);
		}
	}
	
	ds_map_destroy(json);
}