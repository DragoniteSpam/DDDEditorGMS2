/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    argument0.root.selected_property.default_string = argument0.value;
    argument0.root.changed = true;
}