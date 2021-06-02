function serialize_load_entity(buffer, entity, version) {
    entity.name = buffer_read(buffer, buffer_string);
    entity.xx = buffer_read(buffer, buffer_u32);
    entity.yy = buffer_read(buffer, buffer_u32);
    entity.zz = buffer_read(buffer, buffer_u32);
    refid_set(entity, buffer_read(buffer, buffer_datatype));
    
    var state_static = entity.is_static;
    var entity_bools = buffer_read(buffer, buffer_u32);
    entity.is_static = unpack(entity_bools, 0);
    entity.preserve_on_save = unpack(entity_bools, 1);
    entity.reflect = unpack(entity_bools, 2);
    entity.direction_fix = unpack(entity_bools, 3);
    entity.always_update = unpack(entity_bools, 5);
    // same for statics
    if (state_static && !entity.is_static) {
        Stuff.map.active_map.contents.population_static--;
    } else if (!state_static && entity.is_static) {
        Stuff.map.active_map.contents.population_static++;
    }
    
    var n_events = buffer_read(buffer, buffer_u8);
    repeat (n_events) {
        serialize_load_entity_event_page(buffer, entity, version);
    }
    
    entity.off_xx = buffer_read(buffer, buffer_f32);
    entity.off_yy = buffer_read(buffer, buffer_f32);
    entity.off_zz = buffer_read(buffer, buffer_f32);
    
    entity.rot_xx = buffer_read(buffer, buffer_u16);
    entity.rot_yy = buffer_read(buffer, buffer_u16);
    entity.rot_zz = buffer_read(buffer, buffer_u16);
    
    entity.scale_xx = buffer_read(buffer, buffer_f32);
    entity.scale_yy = buffer_read(buffer, buffer_f32);
    entity.scale_zz = buffer_read(buffer, buffer_f32);
    
    entity.autonomous_movement = buffer_read(buffer, buffer_u8);
    entity.autonomous_movement_speed = buffer_read(buffer, buffer_u8);
    entity.autonomous_movement_frequency = buffer_read(buffer, buffer_u8);
    entity.autonomous_movement_route = buffer_read(buffer, buffer_datatype);
    
    var n_move_routes = buffer_read(buffer, buffer_u8);
    repeat (n_move_routes) {
        serialize_load_move_route(buffer, entity, version);
    }
    
    entity.switches = [];
    entity.variables = [];
    
    var n_variables = buffer_read(buffer, buffer_u8);
    repeat (n_variables) {
        array_push(entity.switches, buffer_read(buffer, buffer_bool));
        array_push(entity.variables, buffer_read(buffer, buffer_f32));
    }
    
    while (array_length(entity.switches) < BASE_SELF_VARIABLES) {
        array_push(entity.switches, false);
    }
    while (array_length(entity.variables) < BASE_SELF_VARIABLES) {
        array_push(entity.variables, 0);
    }
    
    var n_generic = buffer_read(buffer, buffer_u8);
    var index = 0;
    entity.generic_data = array_create(n_generic);
    repeat (n_generic) {
        var data = instance_create_depth(0, 0, 0, DataAnonymous);
        
        data.name = buffer_read(buffer, buffer_string);
        data.type = buffer_read(buffer, buffer_u8);
        
        switch (data.type) {
            case DataTypes.INT: data.value_int = buffer_read(buffer, buffer_s32); break;
            case DataTypes.FLOAT: data.value_real = buffer_read(buffer, buffer_f32); break;
            case DataTypes.STRING: data.value_string = buffer_read(buffer, buffer_string); break;
            case DataTypes.BOOL: data.value_bool = buffer_read(buffer, buffer_u8); break;
            case DataTypes.CODE: data.value_code = buffer_read(buffer, buffer_string); break;
            case DataTypes.COLOR: data.value_color = buffer_read(buffer, buffer_u32); break;
            case DataTypes.ASSET_FLAG: data.value_bool = buffer_read(buffer, buffer_flag); break;
            
            case DataTypes.ENUM:
            case DataTypes.DATA:
                data.value_type_guid = buffer_read(buffer, buffer_datatype);
                data.value_data = buffer_read(buffer, buffer_datatype);
                break;
            
            case DataTypes.MESH:
            case DataTypes.MESH_AUTOTILE:
            case DataTypes.IMG_TEXTURE:
            case DataTypes.AUDIO_BGM:
            case DataTypes.AUDIO_SE:
            case DataTypes.ANIMATION:
            case DataTypes.MAP:
            case DataTypes.IMG_BATTLER:
            case DataTypes.IMG_OVERWORLD:
            case DataTypes.IMG_PARTICLE:
            case DataTypes.IMG_UI:
            case DataTypes.IMG_SKYBOX:
            case DataTypes.IMG_ETC:
            case DataTypes.EVENT:
            case DataTypes.IMG_TILE_ANIMATION:
                data.value_data = buffer_read(buffer, buffer_datatype);
                break;
            
            case DataTypes.TILE: not_yet_implemented(); break;
            case DataTypes.ENTITY: not_yet_implemented(); break;
        }
        
        entity.generic_data[@ index++] = data;
    }
    
    entity.slope = buffer_read(buffer, buffer_u8);
}