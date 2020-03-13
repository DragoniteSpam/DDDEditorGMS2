/// @param UIInput

var input = argument0;

// @todo else make it red or something
if (validate_code(input.value, input)) {
    input.root.selected_property.default_code = input.value;
}