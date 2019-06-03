/// @description uivc_settings_map_fog_end(UIThing);
/// @param UIThing

if (script_execute(argument0.validation, argument0.value)) {
    var rv=real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        ActiveMap.fog_end=rv;
    }
}
