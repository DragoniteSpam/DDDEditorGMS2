function InstantiatedEvent(name) constructor {
    self.name = name;
    
    // conditions - these just mirror RPG Maker currently. I'm not sure if all, if any, will
    // be used and will probably try to figure out how to implement Lua or something instead
    self.enabled = true;
    
    // the variable comparison values need to be numbers (floats), by the way
    self.condition_switch_global_enabled = false;
    self.condition_switch_global = 0;                                        // switch index
    self.condition_switch_global_state = true;
    
    self.condition_variable_global_enabled = false;
    self.condition_variable_global = 0;                                      // variable index
    self.condition_variable_global_comparison = Comparisons.EQUAL;
    self.condition_variable_global_value = 0;                                // value to check against
    
    self.condition_switch_self_enabled = false;
    self.condition_switch_self = 0;                                          // switch index
    self.condition_switch_self_state = true;
    
    self.condition_variable_self_enabled = false;
    self.condition_variable_self = 0;                                        // variable index
    self.condition_variable_self_comparison = Comparisons.EQUAL;
    self.condition_variable_self_value = 0;                                  // value to check against
    
    // no actor condition because I don't foresee those being used
    self.condition_code_enabled = false;
    self.condition_code = Stuff.default_lua_event_page_condition;
    
    // by default the zeroth event trigger (probably the action button) is enabled
    self.trigger = 0x01;
    
    self.event_entrypoint = NULL;
    
    static Export = function(buffer) {
        buffer_write(buffer, buffer_field, pack(self.enabled,
            self.condition_switch_global_enabled,
            self.condition_switch_global_state,
            self.condition_variable_global_enabled,
            self.condition_switch_self_enabled,
            self.condition_switch_self_state,
            self.condition_variable_self_enabled,
            self.condition_code_enabled,
        ));
        
        buffer_write(buffer, buffer_u16, self.condition_switch_global);
        buffer_write(buffer, buffer_u16, self.condition_variable_global);
        buffer_write(buffer, buffer_u16, self.condition_switch_self);
        buffer_write(buffer, buffer_u16, self.condition_variable_self);
        
        buffer_write(buffer, buffer_u8, self.condition_variable_global_comparison);
        buffer_write(buffer, buffer_f32, self.condition_variable_global_value);
        buffer_write(buffer, buffer_u8, self.condition_variable_self_comparison);
        buffer_write(buffer, buffer_f32, self.condition_variable_self_value);
        
        buffer_write(buffer, buffer_string, self.condition_code);
        
        buffer_write(buffer, buffer_flag, self.trigger);
        buffer_write(buffer, buffer_datatype, self.event_entrypoint);
    }
}

enum Comparisons {
    LESS,
    LESS_OR_EQUAL,
    EQUAL,
    GREATER_OR_EQUAL,
    GREATER,
    NOT_EQUAL
}

enum ConditionBasicTypes {
    VARIABLE,
    SWITCH,
    SELF_VARIABLE,
    SELF_SWITCH,
    SCRIPT
}