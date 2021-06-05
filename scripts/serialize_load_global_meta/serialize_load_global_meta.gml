function serialize_load_global_meta(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    Game.start.map = buffer_read(buffer, buffer_datatype);
    Game.start.x = buffer_read(buffer, buffer_u16);
    Game.start.y = buffer_read(buffer, buffer_u16);
    Game.start.z = buffer_read(buffer, buffer_u16);
    Game.start.direction = buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_f32);
    Game.lighting.ambient = buffer_read(buffer, buffer_u32);
    
    Game.project.id = buffer_read(buffer, buffer_string);
    Game.grid.chunk_size = buffer_read(buffer, buffer_u16);
    
    buffer_read(buffer, buffer_string);
    
    var bools = buffer_read(buffer, buffer_u32);
    Game.grid.snap = unpack(bools, 0);
    
    Game.screen.width = buffer_read(buffer, buffer_s16);
    Game.screen.height = buffer_read(buffer, buffer_s16);
    
    var n_switches = buffer_read(buffer, buffer_u16);
    var n_variables = buffer_read(buffer, buffer_u16);
    
    Game.switches = array_create(n_switches);
    Game.variables = array_create(n_variables);
    for (var i = 0; i < n_switches; i++) {
        var sw_data = new DataValue("");
        sw_data.name = buffer_read(buffer, buffer_string);
        sw_data.value = buffer_read(buffer, buffer_bool);
        Game.switches[i] = sw_data;
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = new DataValue("");
        var_data.name = buffer_read(buffer, buffer_string);
        var_data.value = buffer_read(buffer, buffer_f32);
        Game.variables[i] = var_data;
    }
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        Game.all_event_triggers[i] = buffer_read(buffer, buffer_string);
    }
    
    var n_constants = buffer_read(buffer, buffer_u16);
    repeat (n_constants) {
        var what = new DataConstant("");
        
        what.name = buffer_read(buffer, buffer_string);
        buffer_read(buffer, buffer_string);
        what.flags = buffer_read(buffer, buffer_u32);
        buffer_read(buffer, buffer_datatype);
        buffer_read(buffer, buffer_string);
        
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
        
        array_push(Game.all_game_constants, what);
    }
    
    Game.project.notes = buffer_read(buffer, buffer_string);
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        Game.all_asset_flags[i] = buffer_read(buffer, buffer_string);
    }
}