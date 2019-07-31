/// @param v0
/// @param v1
/// @param f

// weird arguments but they match the format used by http://www.gizma.com/easing
var t = argument2 * 2;
var b = argument0;
var c = argument1 - argument0;

if (t < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b;
t = t - 2;
return c / 2 * (sqrt(1 - t * t) + 1) + b;