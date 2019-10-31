/// @param terrain
/// @param x
/// @param y

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var index = (xx * terrain.height + yy) * buffer_sizeof(buffer_u32);

return buffer_peek(terrain.color_data, index, buffer_f32);