/// @param terrain
/// @param x
/// @param y

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var index = (xx * terrain.height + yy) * terrain.format_size;

return buffer_peek(terrain.terrain_buffer_data, index + 8, buffer_f32);