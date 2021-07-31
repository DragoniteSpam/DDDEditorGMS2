function import_map_tiled_layer_tile(x, y, z, json, columns, alpha, tiled_cache) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    var ts = get_active_tileset();
    
    var layer_data = json.data;
    var layer_name = json.name;
    var layer_height = json.height;
    var layer_width = json.width;
    var layer_alpha = json.opacity;
    var layer_visible = json.visible;
    var layer_data_x = json.x;
    var layer_data_y = json.y;
    var layer_properties = json[$ "properties"];
    var property_map = { };
    
    if (layer_properties != undefined) {
        for (var i = 0; i < array_length(layer_properties); i++) {
            var property = layer_properties[i];
            // don't add map because they're already in the root map
            property_map[$ property.name] = property;
        }
    }
    
    var xoffset = 0;
    var yoffset = 0;
    
    var zoffset;
    if (property_map[$ "Offset"]) {
        zoffset = property_map.Offset.value;
    } else {
        zoffset = 0;
    }
    
    if (layer_visible) {
        for (var i = 0; i < array_length(layer_data); i++) {
            var tile_x = i mod layer_width;
            var tile_y = i div layer_width;
            var tile_value = layer_data[i];
            
            if (tile_value) {
                tile_value--;
                var tile_tex_x = tile_value mod columns;
                var tile_tex_y = tile_value div columns;
                
                if (is_clamped(tile_x, 0, Stuff.map.active_map.xx - 1) && is_clamped(tile_y, 0, Stuff.map.active_map.yy - 1) && is_clamped(z, 0, Stuff.map.active_map.zz - 1)) {
                    batch_tile_raw(map_contents.frozen_data, map_contents.frozen_data_wire, tile_x, tile_y, z, tile_tex_x, tile_tex_y, c_white, layer_alpha, 0, 0, zoffset);
                }
            }
        }
    }
    
    return z;
}