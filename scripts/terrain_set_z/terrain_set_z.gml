/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;
var index = (xx * terrain.height + yy) * terrain.format_size;

buffer_poke(terrain.terrain_buffer_data, index + 8, buffer_f32, value);