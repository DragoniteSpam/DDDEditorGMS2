/// @param terrain
/// @param x
/// @param y

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var index = (xx * terrain.height + yy) * 4;

return buffer_peek(terrain.height_data, index, buffer_f32);