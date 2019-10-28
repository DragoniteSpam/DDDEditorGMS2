/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;
var index = (xx * terrain.width + yy) * terrain.format_size;
var existing = buffer_peek(terrain.terrain_buffer_data, index + 8, buffer_f32);

buffer_poke(terrain.terrain_buffer_data, index + 8, buffer_f32, existing + value);