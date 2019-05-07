/// @description  void serialize_save_entity_event_page(buffer, DataInstantiatedEvent);
/// @param buffer
/// @param  DataInstantiatedEvent

// name, guid, flags
serialize_save_generic(argument0, argument1);

var bools=pack(argument1.enabled,
    argument1.condition_switch_global_enabled,
    argument1.condition_variable_global_enabled,
    argument1.condition_switch_self_enabled,
    argument1.condition_variable_self_enabled,
    argument1.condition_item_enabled,
    argument1.condition_code_enabled);

// the u16 is just future-proofing - i somewhat doubt that other
// condition types are going to be added but just in case they are
// i don't want to have to check for two different data types
buffer_write(argument0, buffer_u16, bools);

buffer_write(argument0, buffer_u16, argument1.condition_switch_global);
buffer_write(argument0, buffer_u16, argument1.condition_variable_global);
buffer_write(argument0, buffer_u16, argument1.condition_switch_self);
buffer_write(argument0, buffer_u16, argument1.condition_variable_self);
buffer_write(argument0, buffer_u16, argument1.condition_item);
// i don't know how this is going to be implemented - yet. it'll
// probably be a string but there may be a better way of handling
// scripting code.
//buffer_write(argument0, buffer_string, argument1.condition_code);

buffer_write(argument0, buffer_u8, argument1.condition_variable_global_comparison);
buffer_write(argument0, buffer_f32, argument1.condition_variable_global_value);
buffer_write(argument0, buffer_u8, argument1.condition_variable_self_comparison);
buffer_write(argument0, buffer_f32, argument1.condition_variable_self_value);

// these have been removed but i don't feel like screwing with versioning

/*buffer_write(argument0, buffer_u8, argument1.autonomous_movement);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_speed);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_frequency);*/
// skip the move route stuff for now

/*var bools=pack(argument1.option_animate_movement0,
    argument1.option_animate_idle0,
    argument1.option_direction_fix0);*/

var bools=0;

// more future-proofing
buffer_write(argument0, buffer_u16, bools);

buffer_write(argument0, buffer_u8, argument1.trigger);

buffer_write(argument0, buffer_u32, argument1.event_guid);
buffer_write(argument0, buffer_u32, argument1.event_entrypoint);
