function serialize_save_global_meta(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.GLOBAL_METADATA);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_datatype, Game.meta.start.map);
    buffer_write(buffer, buffer_u16, Game.meta.start.x);
    buffer_write(buffer, buffer_u16, Game.meta.start.y);
    buffer_write(buffer, buffer_u16, Game.meta.start.z);
    buffer_write(buffer, buffer_u8, Game.meta.start.direction);
    buffer_write(buffer, buffer_f32, 255);
    buffer_write(buffer, buffer_u32, Game.meta.lighting.ambient);
    buffer_write(buffer, buffer_string, Game.meta.project.id);
    buffer_write(buffer, buffer_u16, Game.meta.grid.chunk_size);
    
    buffer_write(buffer, buffer_string, "");
    
    var bools = pack(Game.meta.grid.snap);
    buffer_write(buffer, buffer_u32, bools);
    
    buffer_write(buffer, buffer_s16, Game.meta.screen.width);
    buffer_write(buffer, buffer_s16, Game.meta.screen.height);
    
    var n_switches = array_length(Game.vars.switches);
    var n_variables = array_length(Game.vars.variables);
    buffer_write(buffer, buffer_u16, n_switches);
    buffer_write(buffer, buffer_u16, n_variables);
    
    for (var i = 0; i < n_switches; i++) {
        var sw_data = Game.vars.switches[i];
        buffer_write(buffer, buffer_string, sw_data.name);
        buffer_write(buffer, buffer_bool, sw_data.value);
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = Game.vars.variables[i];
        buffer_write(buffer, buffer_string, var_data.name);
        buffer_write(buffer, buffer_f32, var_data.value);
    }
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        buffer_write(buffer, buffer_string, Game.vars.triggers[i]);
    }
    
    var n_constants = array_length(Game.vars.constants);
    buffer_write(buffer, buffer_u16, n_constants);
    for (var i = 0; i < n_constants; i++) {
        var what = Game.vars.constants[i];
        serialize_save_generic(buffer, what);
        
        buffer_write(buffer, buffer_u16, what.type);
        buffer_write(buffer, buffer_datatype, what.type_guid);
        buffer_write(buffer, buffer_f32, what.value_real);
        buffer_write(buffer, buffer_string, what.value_string);
        buffer_write(buffer, buffer_datatype, what.value_guid);
    }
    
    buffer_write(buffer, buffer_string, Game.meta.project.notes);
    
    for (var i = 0; i < FLAG_COUNT; i++) {
        buffer_write(buffer, buffer_string, Game.vars.flags[i]);
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}