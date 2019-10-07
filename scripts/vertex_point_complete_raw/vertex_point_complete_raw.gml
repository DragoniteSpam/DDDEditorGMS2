/// @param buffer
/// @param x
/// @param y
/// @param z
/// @param nx
/// @param ny
/// @param nz
/// @param xtex
/// @param ytex
/// @param color
/// @param alpha

var buffer = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;
var nx = argument4;
var ny = argument5;
var nz = argument6;
var xtex = argument7;
var ytex = argument8;
var color = argument9;
var alpha = argument10;

buffer_write(buffer, buffer_f32, xx);
buffer_write(buffer, buffer_f32, yy);
buffer_write(buffer, buffer_f32, zz);
buffer_write(buffer, buffer_f32, nx);
buffer_write(buffer, buffer_f32, ny);
buffer_write(buffer, buffer_f32, nz);
buffer_write(buffer, buffer_f32, xtex);
buffer_write(buffer, buffer_f32, ytex);
buffer_write(buffer, buffer_u32, (floor(alpha * 255) << 24) | colour_reverse(color));
buffer_write(buffer, buffer_u32, 0x00000000);