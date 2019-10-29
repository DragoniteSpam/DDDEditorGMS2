/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;
var existing = terrain_get_z(terrain, xx, yy);

terrain_set_z(terrain, xx, yy, existing + value);