/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var rv = real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        argument0.root.selected_property.max_size = rv;
        argument0.root.changed = true;
    }
}