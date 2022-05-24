function import_map_tiled(ask_clear = true) {
    if (ask_clear) {
        emu_dialog_confirm(undefined, "Do you want to import a Tiled map? If there is any frozen terrain data, it will be removed.", function() {
            var map = Stuff.map.active_map;
            var map_contents = map.contents;
            if (map_contents.water_data) buffer_delete(map_contents.water_data);
            if (map_contents.frozen_data) buffer_delete(map_contents.frozen_data);
            map_contents.frozen_data = buffer_create(1, buffer_grow, DEFAULT_FROZEN_BUFFER_SIZE);
            map_contents.water_data = buffer_create(1, buffer_grow, DEFAULT_FROZEN_BUFFER_SIZE);
            // the vertex buffers are created elsewhere - since they need to be
            // destroyed and recreated regardless
            import_map_tiled(false);
            self.root.Dispose();
        });
        return;
    }
    
    var filename = get_open_filename_tiled();
    
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    if (!file_exists(filename)) return;
    
    var json_buffer = buffer_load(filename);
    var json = json_parse(buffer_read(json_buffer, buffer_text));
    buffer_delete(json_buffer);
    
    var json_type = json.type;
    if (json_type != "map") return;
    
    var tiled_cache = { };
    tiled_cache[$ "*dir"] = filename_dir(filename);
    
    var json_layers = json.layers;
    var json_properties = json[$ "properties"];
    var map_id = -1;
    
    for (var i = 0; i < array_length(json_properties); i++) {
        var property_name = json_properties[i].name;
        var property_type = json_properties[i].type;
        var property_value = json_properties[i].value;
        
        if (property_name == "id") {
            map_id = property_value;
        }
    }
    
    map.tiled_map_id = map_id;
    
    var json_width = json.width;
    var json_height = json.height;
    var json_tilesets = json.tilesets;
    var gid_cache = { };
    tiled_cache[$ "%tilesets"] = json_tilesets;
    tiled_cache[$ "&gid"] = gid_cache;
    var tileset_columns = 0;
    
    // the main ts used by the map
    if (!array_empty(json_tilesets)) {
        var tileset_source = json_tilesets[0].source;
        if (!file_exists(tileset_source)) {
            tileset_source = filename_path(filename) + filename_name(tileset_source);
        }
        if (file_exists(tileset_source)) {
            var tileset_buffer = buffer_load(tileset_source);
            var tileset_json = json_parse(buffer_read(json_buffer, buffer_text));
            buffer_delete(tileset_buffer);
            tileset_columns = tileset_json.columns;
        }
    }
    
    // existing entities need to be logged
    var tmx_ids = { };
    for (var i = 0; i < array_length(map_contents.all_entities); i++) {
        tmx_ids[$ entity.tmx_id] = map_contents.all_entities[i];
    }
    tiled_cache[$ "&tmx-ids"] = tmx_ids;
    
    if (tileset_columns) {
        array_clear_3d(map.grid_flags, 0);
        
        var layer_z = 0;
        for (var i = 0; i < array_length(json_layers); i++) {
            var layer_data = json_layers[i];
            var layer_type = layer_data.type;
            
            switch (layer_type) {
                case "group": layer_z = import_map_tiled_layer_folder(0, 0, layer_z, layer_data, tileset_columns, 1, tiled_cache); break;
                case "objectgroup": layer_z = import_map_tiled_layer_object(0, 0, layer_z, layer_data, tileset_columns, 1, tiled_cache); break;
                case "tilelayer": layer_z = import_map_tiled_layer_tile(0, 0, layer_z, layer_data, tileset_columns, 1, tiled_cache); break;
            }
        }
        
        if (map_contents.frozen) vertex_delete_buffer(map_contents.frozen);
        if (map_contents.water) vertex_delete_buffer(map_contents.water);
        
        buffer_resize(map_contents.water_data, buffer_tell(map_contents.water_data));
        buffer_resize(map_contents.frozen_data, buffer_tell(map_contents.frozen_data));
        
        if (buffer_get_size(map_contents.frozen_data) - 1) {
            map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Stuff.graphics.format);
            vertex_freeze(map_contents.frozen);
        } else {
            buffer_delete(map_contents.frozen_data);
            map_contents.frozen_data = undefined;
        }
        if (buffer_get_size(map_contents.reflect_frozen_data) - 1) {
            map_contents.reflect_frozen = vertex_create_buffer_from_buffer(map_contents.reflect_frozen_data, Stuff.graphics.format);
            vertex_freeze(map_contents.reflect_frozen);
        } else {
            buffer_delete(map_contents.reflect_frozen_data);
            map_contents.reflect_frozen_data = undefined;
        }
        if (buffer_get_size(map_contents.water_data) - 1) {
            map_contents.water = vertex_create_buffer_from_buffer(map_contents.water_data, Stuff.graphics.format);
            vertex_freeze(map_contents.water);
        } else {
            buffer_delete(map_contents.water_data);
            map_contents.water_data = undefined;
        }
    } else {
        emu_dialog_notice("No valid tileset file found for " + filename_name(filename) + ". Please find one.");
    }
        
    batch_again();
}