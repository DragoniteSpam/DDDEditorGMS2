/// @param UIInput

var rv = real(argument0.value);
if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
    argument0.root.selected_property.default_int = rv;
    argument0.root.changed = true;
}