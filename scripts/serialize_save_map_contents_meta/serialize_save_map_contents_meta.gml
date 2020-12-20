function serialize_save_map_contents_meta(buffer) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    buffer_write(buffer, buffer_u32, SerializeThings.MAP_META);
    var addr_skip = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
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
    buffer_write(buffer, buffer_f32, map.water_level);
    buffer_write(buffer, buffer_u32, map.light_ambient_colour);
    buffer_write(buffer, buffer_datatype, map.skybox);
    buffer_write(buffer, buffer_u16, map.map_chunk_size);
    
    var bools = pack(
        map.indoors,
        map.draw_water,
        map.fast_travel_to,
        map.fast_travel_from,
        map.is_3d,
        map.fog_enabled,
        map.on_grid,
        map.reflections_enabled,
        map.light_player_enabled,
        map.light_enabled,
    );
    
    buffer_write(buffer, buffer_u32, bools);
    buffer_write(buffer, buffer_string, map.code);
    
    #region generic data
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
            
            case DataTypes.MESH:
            case DataTypes.MESH_AUTOTILE:
            case DataTypes.IMG_TEXTURE:
            case DataTypes.AUDIO_BGM:
            case DataTypes.AUDIO_SE:
            case DataTypes.ANIMATION:
            case DataTypes.MAP:
            case DataTypes.IMG_TILE_ANIMATION:
            case DataTypes.IMG_BATTLER:
            case DataTypes.IMG_OVERWORLD:
            case DataTypes.IMG_PARTICLE:
            case DataTypes.IMG_UI:
            case DataTypes.IMG_SKYBOX:
            case DataTypes.IMG_ETC:
            case DataTypes.EVENT:
            case DataTypes.ENTITY:
                buffer_write(buffer, buffer_datatype, data.value_data);
                break;
            
            case DataTypes.TILE: not_yet_implemented(); break;
        }
    }
    #endregion
    
    var n_lights = ds_list_size(map_contents.active_lights);
    buffer_write(buffer, buffer_u16, n_lights);
    for (var i = 0; i < n_lights; i++) {
        buffer_write(buffer, buffer_datatype, map_contents.active_lights[| i]);
    }
    
    buffer_poke(buffer, addr_skip, buffer_u64, buffer_tell(buffer));
}