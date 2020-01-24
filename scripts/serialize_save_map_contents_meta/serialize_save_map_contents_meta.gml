/// @param buffer

var buffer = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_META);

// signed because it's allowed to be -1
buffer_write(buffer, buffer_s32, map.tiled_map_id);

buffer_write(buffer, buffer_u16, map.xx);
buffer_write(buffer, buffer_u16, map.yy);
buffer_write(buffer, buffer_u16, map.zz);

buffer_write(buffer, buffer_datatype, map.tileset);

buffer_write(buffer, buffer_f32, map.fog_start);
buffer_write(buffer, buffer_f32, map.fog_end);
buffer_write(buffer, buffer_u32, map.fog_colour);
buffer_write(buffer, buffer_u32, map.base_encounter_rate);
buffer_write(buffer, buffer_u32, map.base_encounter_deviation);

var bools = pack(map.indoors, map.draw_water, map.fast_travel_to, map.fast_travel_from, map.is_3d, map.fog_enabled, map.on_grid);

buffer_write(buffer, buffer_u32, bools);
buffer_write(buffer, buffer_string, map.code);

for (var i = 0; i < array_length_1d(map_contents.mesh_autotile_raw); i++) {
    var data = map_contents.mesh_autotile_raw[i];
    if (data) {
        buffer_write(buffer, buffer_bool, true);
        buffer_write(buffer, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(buffer, data);
    } else {
        buffer_write(buffer, buffer_bool, false);
    }
}

for (var i = 0; i < array_length_1d(map_contents.mesh_autotile_vertical_raw); i++) {
    var data = map_contents.mesh_autotile_vertical_raw[i];
    if (data) {
        buffer_write(buffer, buffer_bool, true);
        buffer_write(buffer, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(buffer, data);
    } else {
        buffer_write(buffer, buffer_bool, false);
    }
}

var n_generic = ds_list_size(map.generic_data);
buffer_write(buffer, buffer_u8, n_generic);

for (var i = 0; i < n_generic; i++) {
    var data = map.generic_data[| i];
    buffer_write(buffer, buffer_string, data.name);
    buffer_write(buffer, buffer_u8, data.type);
    
    switch (data.type) {
        case DataTypes.INT: buffer_write(buffer, buffer_s32, data.value_int); break;
        case DataTypes.FLOAT: buffer_write(buffer, buffer_f32, data.value_real); break;
        case DataTypes.STRING: buffer_write(buffer, buffer_string, data.value_string); break;
        case DataTypes.BOOL: buffer_write(buffer, buffer_u8, data.value_bool); break;
        case DataTypes.CODE: buffer_write(buffer, buffer_string, data.value_code); break;
        case DataTypes.COLOR: buffer_write(buffer, buffer_u32, data.value_color); break;
        
        case DataTypes.ENUM:
        case DataTypes.DATA:
            buffer_write(buffer, buffer_datatype, data.value_type_guid);
            buffer_write(buffer, buffer_datatype, data.value_data);
            break;
        
        case DataTypes.MESH: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_TILESET: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.AUDIO_BGM: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.AUDIO_SE: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.ANIMATION: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.MAP: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_BATTLER: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_OVERWORLD: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_PARTICLE: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_UI: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.IMG_ETC: buffer_write(buffer, buffer_datatype, data.value_data); break;
        case DataTypes.EVENT: buffer_write(buffer, buffer_datatype, data.value_data); break;
        
        case DataTypes.TILE: not_yet_implemented(); break;
        case DataTypes.AUTOTILE: not_yet_implemented(); break;
        case DataTypes.ENTITY: not_yet_implemented(); break;
    }
}