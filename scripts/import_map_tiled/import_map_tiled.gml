/// @param [ask-clear-frozen?]

var ask_clear = (argument_count > 0) ? argument[0] : false;

if (ask_clear) {
    dialog_create_yes_or_no(noone, "Do you want to import a Tiled map? If there is any frozen terrain data, it will be removed.", dmu_data_import_map_act);
    return;
}

var filename = get_open_filename_tiled();

var map = Stuff.map.active_map;
var map_contents = map.contents;

if (file_exists(filename)) {
    var json_buffer = buffer_load(filename);
    var json = json_decode(buffer_read(json_buffer, buffer_text));
    buffer_delete(json_buffer);
    
    var json_type = json[? "type"];
    if (json_type == "map") {
        var tiled_cache = ds_map_create();
        tiled_cache[? "*dir"] = filename_dir(filename);
        
        var json_layers = json[? "layers"];
        
        var json_properties = json[? "properties"];
        var map_id = -1;
        
        if (json_properties) {
            for (var i = 0; i < ds_list_size(json_properties); i++) {
                var property_name = ds_map_find_value(json_properties[| i], "name");
                var property_type = ds_map_find_value(json_properties[| i], "type");
                var property_value = ds_map_find_value(json_properties[| i], "value");
            
                if (property_name = "id") {
                    map_id = property_value;
                }
            }
        }
        
        Stuff.tiled_map_id = map_id;
        
        var json_width = json[? "width"];
        var json_height = json[? "height"];
        
        var json_tilesets = json[? "tilesets"];
        var gid_cache = ds_map_create();
        ds_map_add(tiled_cache, "%tilesets", json_tilesets); // don't mark as map
        ds_map_add_map(tiled_cache, "&gid", gid_cache);
        var tileset_columns = 0;
        
        if (!ds_list_empty(json_tilesets)) {
            // @todo gml update chained accessors
            var tileset_source = ds_map_find_value(json_tilesets[| 0], "source");
            if (!file_exists(tileset_source)) {
                tileset_source = filename_path(filename) + filename_name(tileset_source);
            }
            if (file_exists(tileset_source)) {
                var tileset_buffer = buffer_load(tileset_source);
                var tileset_json = json_decode(buffer_read(json_buffer, buffer_text));
                buffer_delete(tileset_buffer);
                tileset_columns = tileset_json[? "columns"];
                ds_map_destroy(tileset_json);
            }
        }
        
        // existing entities need to be logged
        var tmx_ids = ds_map_create();
        for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
            var entity = map_contents.all_entities[| i];
            tmx_ids[? entity.tmx_id] = entity;
        }
        ds_map_add_map(tiled_cache, "&tmx-ids", tmx_ids);
        
        if (tileset_columns) {
            buffer_seek(map_contents.frozen_data, buffer_seek_start, map_contents.frozen_data_size);
            buffer_seek(map_contents.frozen_data_wire, buffer_seek_start, map_contents.frozen_data_wire_size);
            
            // clear any anonymous collision data that may have been left behind by the previous map
            for (var i = 0; i < map.xx; i++) {
                for (var j = 0; j < map.yy; j++) {
                    for (var k = 0; k < map.zz; k++) {
                        var slice = map_get_grid_cell(i, j, k, map);
                        if (is_clamped(slice[@ MapCellContents.TILE], ANONYMOUS_COLLISION_BASE, ANONYMOUS_COLLISION_BASE + ANONYMOUS_COLLISION_BASE)) {
                            slice[@ MapCellContents.TILE] = noone;
                        }
                    }
                }
            }
            
            var json_layers = json[? "layers"];
            var layer_z = 0;
            for (var i = 0; i < ds_list_size(json_layers); i++) {
                var layer_data = json_layers[| i];
                var layer_type = layer_data[? "type"];
            
                switch (layer_type) {
                    case "group": layer_z = import_map_tiled_layer_folder(layer_data, tileset_columns, layer_z, 1, 0, 0, tiled_cache); break;
                    case "objectgroup": layer_z = import_map_tiled_layer_object(layer_data, tileset_columns, layer_z, 1, 0, 0, tiled_cache); break;
                    case "tilelayer": layer_z = import_map_tiled_layer_tile(layer_data, tileset_columns, layer_z, 1, 0, 0, tiled_cache); break;
                }
            }
            
            if (map_contents.frozen) vertex_delete_buffer(map_contents.frozen);
            if (map_contents.frozen_wire) vertex_delete_buffer(map_contents.frozen_wire);
            
            map_contents.frozen_data_size = buffer_tell(map_contents.frozen_data);
            map_contents.frozen_data_wire_size = buffer_tell(map_contents.frozen_data_wire);
            
            if (buffer_get_size(map_contents.frozen_data) - 1) {
                map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Stuff.graphics.vertex_format);
                vertex_freeze(map_contents.frozen);
            }
            if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
                map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Stuff.graphics.vertex_format);
                vertex_freeze(map_contents.frozen_wire);
            }
            
        } else {
            dialog_create_notice(noone, "No valid tileset file found for " + filename_name(filename) + ". Please find one.");
        }
        
        ds_map_destroy(tiled_cache);
    }
    
    ds_map_destroy(json);
}