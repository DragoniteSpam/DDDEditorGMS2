/// @param buffer
/// @param Entity
/// @param version

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
// bools[5] used to be item enabled, but we ditched that
page.condition_code_enabled = unpack(bools, 6);

page.condition_switch_global = buffer_read(buffer, buffer_u16);
page.condition_variable_global = buffer_read(buffer, buffer_u16);
page.condition_switch_self = buffer_read(buffer, buffer_u16);
page.condition_variable_self = buffer_read(buffer, buffer_u16);

if (version >= DataVersions.EVENT_PAGE_CODE_CONDITION) {
    page.condition_code = buffer_read(buffer, buffer_string);
} else {
    buffer_read(buffer, buffer_u16);
}

page.condition_variable_global_comparison = buffer_read(buffer, buffer_u8);
page.condition_variable_global_value = buffer_read(buffer, buffer_f32);
page.condition_variable_self_comparison = buffer_read(buffer, buffer_u8);
page.condition_variable_self_value = buffer_read(buffer, buffer_f32);

var bools = buffer_read(buffer, buffer_u16);

page.trigger = buffer_read(buffer, buffer_u8);

page.event_guid = buffer_read(buffer, buffer_u32);
page.event_entrypoint = buffer_read(buffer, buffer_u32);

ds_list_add(entity.object_events, page);