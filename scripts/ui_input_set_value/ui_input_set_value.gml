/// @param UIInput
/// @param value
// because keyboard_string also needs to be set

var input = argument0;
var value = argument1;

input.value = value;

if (ui_is_active(input)) {
    keyboard_string = value;
}