/// @param terrain
/// @param x
/// @param y
/// @param dir
/// @param average
/// @param dist

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var dir = argument3;
var avg = argument4;
var dist = argument5;

terrain_add_z(terrain, xx, yy, dir * (power(terrain.rate, 1.25) + 0.5) * max(1, dist));