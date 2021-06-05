function serialize_save_global_meta(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.GLOBAL_METADATA);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_datatype, Stuff.game_starting_map);
    buffer_write(buffer, buffer_u16, Stuff.game_starting_x);
    buffer_write(buffer, buffer_u16, Stuff.game_starting_y);
    buffer_write(buffer, buffer_u16, Stuff.game_starting_z);
    buffer_write(buffer, buffer_u8, Stuff.game_starting_direction);
    buffer_write(buffer, buffer_f32, Stuff.game_lighting_buckets);
    buffer_write(buffer, buffer_u32, Stuff.game_lighting_default_ambient);
    buffer_write(buffer, buffer_string, Game.project.id);
    buffer_write(buffer, buffer_u16, Stuff.game_base_map_chunk_size);
    
    buffer_write(buffer, buffer_string, Stuff.game_common_effect_code);
    
    var bools = pack(Stuff.game_player_grid);
    buffer_write(buffer, buffer_u32, bools);
    
    buffer_write(buffer, buffer_s16, Stuff.game_screen_base_width);
    buffer_write(buffer, buffer_s16, Stuff.game_screen_base_height);
    
    var n_switches = array_length(Game.switches);
    var n_variables = array_length(Game.variables);
    buffer_write(buffer, buffer_u16, n_switches);
    buffer_write(buffer, buffer_u16, n_variables);
    
    for (var i = 0; i < n_switches; i++) {
        var sw_data = Game.switches[i];
        buffer_write(buffer, buffer_string, sw_data.name);
        buffer_write(buffer, buffer_bool, sw_data.value);
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = Game.variables[i];
        buffer_write(buffer, buffer_string, var_data.name);
        buffer_write(buffer, buffer_f32, var_data.value);
    }
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        buffer_write(buffer, buffer_string, Game.all_event_triggers[i]);
    }
    
    var n_constants = array_length(Game.all_game_constants);
    buffer_write(buffer, buffer_u16, n_constants);
    for (var i = 0; i < n_constants; i++) {
        var what = Game.all_game_constants[i];
        serialize_save_generic(buffer, what);
        
        buffer_write(buffer, buffer_u16, what.type);
        buffer_write(buffer, buffer_datatype, what.type_guid);
        buffer_write(buffer, buffer_f32, what.value_real);
        buffer_write(buffer, buffer_string, what.value_string);
        buffer_write(buffer, buffer_datatype, what.value_guid);
    }
    
    buffer_write(buffer, buffer_string, Game.project.notes);
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        buffer_write(buffer, buffer_string, Game.all_asset_flags[i]);
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}