/// @param buffer
/// @param DataInstantiatedEvent

var buffer = argument0;
var event = argument1;

// name, guid, flags
serialize_save_generic(buffer, event);

var bools = pack(event.enabled,
    event.condition_switch_global_enabled,
    event.condition_variable_global_enabled,
    event.condition_switch_self_enabled,
    event.condition_variable_self_enabled,
    0,                                              // used to be condition_item_enabled, now just blank
    event.condition_code_enabled
);

// the u16 is just future-proofing - i somewhat doubt that other
// condition types are going to be added but just in case they are
// i don't want to have to check for two different data types
buffer_write(buffer, buffer_u16, bools);

buffer_write(buffer, buffer_u16, event.condition_switch_global);
buffer_write(buffer, buffer_u16, event.condition_variable_global);
buffer_write(buffer, buffer_u16, event.condition_switch_self);
buffer_write(buffer, buffer_u16, event.condition_variable_self);
buffer_write(buffer, buffer_string, event.condition_code);

buffer_write(buffer, buffer_u8, event.condition_variable_global_comparison);
buffer_write(buffer, buffer_f32, event.condition_variable_global_value);
buffer_write(buffer, buffer_u8, event.condition_variable_self_comparison);
buffer_write(buffer, buffer_f32, event.condition_variable_self_value);

var bools = 0;

// more future-proofing
buffer_write(buffer, buffer_u16, bools);

buffer_write(buffer, buffer_u32, event.trigger);
buffer_write(buffer, buffer_datatype, event.event_entrypoint);