/// @param UIInput

// @todo else make it red or something
if (validate_code(argument0.value)) {
    argument0.root.selected_property.default_code = argument0.value;
    argument0.root.changed = true;
}