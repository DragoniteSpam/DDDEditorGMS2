/// @param buffer
/// @param Entity
/// @param version
function serialize_load_entity_event_page(argument0, argument1, argument2) {

    var buffer = argument0;
    var entity = argument1;
    var version = argument2;

    var page = create_instantiated_event("");
    serialize_load_generic(buffer, page, version);

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

    var bools = buffer_read(buffer, buffer_u16);

    page.trigger = buffer_read(buffer, buffer_u32);

    if (version >= DataVersions.NO_EVENT_PAGE_GUID) {
    } else {
        buffer_read(buffer, buffer_get_datatype(version));
    }
    page.event_entrypoint = buffer_read(buffer, buffer_get_datatype(version));

    ds_list_add(entity.object_events, page);


}
