function serialize_load_entity_event_page(buffer, entity, version) {
    var page = new InstantiatedEvent(buffer_read(buffer, buffer_string));
    
    buffer_read(buffer, buffer_string);
    buffer_read(buffer, buffer_u32);
    buffer_read(buffer, buffer_datatype);
    buffer_read(buffer, buffer_string);
    
    var bools = buffer_read(buffer, buffer_u16);
    page.enabled = unpack(bools, 0);
    page.condition_switch_global_enabled = unpack(bools, 1);
    page.condition_variable_global_enabled = unpack(bools, 2);
    page.condition_switch_self_enabled = unpack(bools, 3);
    page.condition_variable_self_enabled = unpack(bools, 4);
    // bools[5] used to be item enabled, but we ditched that so you're
    // free to recycle it now
    page.condition_code_enabled = unpack(bools, 6);
    
    page.condition_switch_global = buffer_read(buffer, buffer_u16);
    page.condition_variable_global = buffer_read(buffer, buffer_u16);
    page.condition_switch_self = buffer_read(buffer, buffer_u16);
    page.condition_variable_self = buffer_read(buffer, buffer_u16);
    
    page.condition_code = buffer_read(buffer, buffer_string);
    
    page.condition_variable_global_comparison = buffer_read(buffer, buffer_u8);
    page.condition_variable_global_value = buffer_read(buffer, buffer_f32);
    page.condition_variable_self_comparison = buffer_read(buffer, buffer_u8);
    page.condition_variable_self_value = buffer_read(buffer, buffer_f32);
    
    bools = buffer_read(buffer, buffer_u16);
    page.trigger = buffer_read(buffer, buffer_u32);
    page.event_entrypoint = buffer_read(buffer, buffer_datatype);
    
    array_push(entity.object_events, page);
}