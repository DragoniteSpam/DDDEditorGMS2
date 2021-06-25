function project_export_global(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.GLOBAL_METADATA);
    buffer_reserve_address(buffer);
    
    buffer_write(buffer, buffer_datatype, Game.meta.start.map);
    buffer_write(buffer, buffer_u16, Game.meta.start.x);
    buffer_write(buffer, buffer_u16, Game.meta.start.y);
    buffer_write(buffer, buffer_u16, Game.meta.start.z);
    buffer_write(buffer, buffer_u8, Game.meta.start.direction);
    buffer_write(buffer, buffer_string, Game.meta.project.id);
    buffer_write(buffer, buffer_u16, Game.meta.grid.chunk_size);
    
    var bools = pack(Game.meta.grid.snap);
    buffer_write(buffer, buffer_field, bools);
    
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
    
    var n_constants = array_length(Game.vars.constants);
    buffer_write(buffer, buffer_u16, n_constants);
    for (var i = 0; i < n_constants; i++) {
        var constant = Game.vars.constants[i];
        var type = Stuff.data_type_meta[constant.type];
        buffer_write(buffer, buffer_u16, type.id);
        buffer_write(buffer, type.buffer_type, constant.value);
    }
    
    buffer_write_address(buffer);
}

function project_export_language(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.GLOBAL_METADATA);
    buffer_reserve_address(buffer);
    
    buffer_write(buffer, buffer_u8, array_length(Game.languages.names));
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        buffer_write(buffer, buffer_string, Game.languages.names[i]);
    }
    
    var keys = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    buffer_write(buffer, buffer_u32, array_length(keys));
    for (var i = 0; i < array_length(keys); i++) {
        buffer_write(buffer, buffer_string, keys[i]);
    }
    
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        var lang = Game.languages.text[$ Game.languages.names[i]];
        for (var j = 0; j < array_length(keys); j++) {
            buffer_write(buffer, buffer_string, lang[$ keys[j]]);
        }
    }
    
    buffer_write_address(buffer);
}

function project_export_animations(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.GLOBAL_METADATA);
    buffer_reserve_address(buffer);
    
    buffer_write(buffer, buffer_u8, array_length(Game.animations));
    for (var i = 0; i < array_length(Game.animations); i++) {
        Game.animations[i].Export(buffer);
    }
    
    buffer_write_address(buffer);
}

function project_export_events(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.EVENTS);
    buffer_reserve_address(buffer);
    
    buffer_write(buffer, buffer_u8, array_length(Game.events));
    for (var i = 0; i < array_length(Game.events); i++) {
        Game.events[i].Export(buffer);
    }
    
    buffer_write_address(buffer);
}