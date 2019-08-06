/// @param v0
/// @param v1
/// @param f

// ease (co)sine in and out

// weird arguments but they match the format used by http://www.gizma.com/easing
var t = argument2;
var b = argument0;
var c = argument1 - argument0;

return -c / 2 * (cos(pi * t) - 1) + b;