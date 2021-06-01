function serialize_load_global_meta(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    Stuff.game_starting_map = buffer_read(buffer, buffer_datatype);
    Stuff.game_starting_x = buffer_read(buffer, buffer_u16);
    Stuff.game_starting_y = buffer_read(buffer, buffer_u16);
    Stuff.game_starting_z = buffer_read(buffer, buffer_u16);
    Stuff.game_starting_direction = buffer_read(buffer, buffer_u8);
    Stuff.game_lighting_buckets = buffer_read(buffer, buffer_f32);
    Stuff.game_lighting_default_ambient = buffer_read(buffer, buffer_u32);
    
    Stuff.game_asset_id = buffer_read(buffer, buffer_string);
    Stuff.game_base_map_chunk_size = buffer_read(buffer, buffer_u16);
    
    Stuff.game_common_effect_code = buffer_read(buffer, buffer_string);
    
    var bools = buffer_read(buffer, buffer_u32);
    Stuff.game_player_grid = unpack(bools, 0);
    
    Stuff.game_screen_base_width = buffer_read(buffer, buffer_s16);
    Stuff.game_screen_base_height = buffer_read(buffer, buffer_s16);
    
    var n_switches = buffer_read(buffer, buffer_u16);
    var n_variables = buffer_read(buffer, buffer_u16);
    
    Stuff.switches = array_create(n_switches);
    Stuff.variables = array_create(n_variables);
    for (var i = 0; i < n_switches; i++) {
        var sw_data = { name: "", value: false };
        sw_data.name = buffer_read(buffer, buffer_string);
        sw_data.value = buffer_read(buffer, buffer_bool);
        Stuff.switches[i] = sw_data;
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = { name: "", value: 0 };
        var_data.name = buffer_read(buffer, buffer_string);
        var_data.value = buffer_read(buffer, buffer_f32);
        Stuff.variables[i] = var_data;
    }
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        Stuff.all_event_triggers[i] = buffer_read(buffer, buffer_string);
    }
    
    var n_constants = buffer_read(buffer, buffer_u16);
    repeat (n_constants) {
        var what = new DataConstant("");
        serialize_load_generic(buffer, what, version);
        
        what.type = buffer_read(buffer, buffer_u16);
        what.type_guid = buffer_read(buffer, buffer_datatype);
        var val_real = buffer_read(buffer, buffer_f32);
        var val_string = buffer_read(buffer, buffer_string);
        var val_guid = buffer_read(buffer, buffer_datatype);
        
        switch (what.type) {
            case DataTypes.INT:
            case DataTypes.FLOAT:
            case DataTypes.BOOL:
            case DataTypes.ASSET_FLAG:
            case DataTypes.COLOR:
                what.value = val_real;
                break;
            case DataTypes.STRING:
            case DataTypes.CODE:
                what.val = val_string;
                break;
            default:
                what.val = val_guid;
                break;
        }
        
        array_push(Stuff.all_game_constants, what);
    }
    
    Stuff.game_notes = buffer_read(buffer, buffer_string);
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        Stuff.all_asset_flags[i] = buffer_read(buffer, buffer_string);
    }
}