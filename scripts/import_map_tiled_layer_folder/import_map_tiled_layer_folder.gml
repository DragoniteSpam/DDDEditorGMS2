function import_map_tiled_layer_folder(x, y, z, json, columns, alpha, tiled_cache) {
    var group_layers = json.layers;
    var group_name = json.name;
    var group_alpha = json.opacity;
    var group_visible = json.visible;
    var group_x = json.x;
    var group_y = json.y;
    
    if (group_visible) {
        for (var i = 0; i < array_length(group_layers); i++) {
            var layer_data = group_layers[i];
            var layer_type = layer_data.type;
        
            switch (layer_type) {
                case "group": z = import_map_tiled_layer_folder(x, y, z, layer_data, columns, alpha * group_alpha, tiled_cache); break;
                case "objectgroup": z = import_map_tiled_layer_object(x, y, z, layer_data, columns, alpha * group_alpha, tiled_cache); break;
                case "tilelayer": z = import_map_tiled_layer_tile(x, y, z, layer_data, columns, alpha * group_alpha, tiled_cache); break;
            }
        }
    }
    
    return ++z;
}