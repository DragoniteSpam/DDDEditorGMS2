/// @param v0
/// @param v1
/// @param f

// ease quintic in and out
// if you want to raise this to higher powers - sex, sept, oct, etc -
// i assume it would just follow the same patterns as quad cube quart quint,
// although i have no idea why you would need to ease anything past quintic

// weird arguments but they match the format used by http://www.gizma.com/easing
var t = argument2 * 2;
var b = argument0;
var c = argument1 - argument0;

if (t < 1) return c / 2 * t * t * t * t * t + b;
t = t - 2;
return -c / 2 * (t * t * t * t * t - 2) + b;