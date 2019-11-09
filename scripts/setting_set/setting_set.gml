/// @param object
/// @param name
/// @param value

var object = argument0;
var name = argument1;
var value = argument2;

var domain = Stuff.settings[? object];

if (domain) {
    domain[? name] = value;
} else {
    show_error("Setting object not found: " + object, false);
}