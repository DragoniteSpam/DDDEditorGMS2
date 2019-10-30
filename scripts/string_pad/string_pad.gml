/// @param value
/// @param char
/// @param n

var value = string(argument[0]);
var char = argument[1];
var padding = (argument_count > 2) ? argument[2] : 0;

while (string_length(value) < padding) {
    value = char + value;
}

return value;