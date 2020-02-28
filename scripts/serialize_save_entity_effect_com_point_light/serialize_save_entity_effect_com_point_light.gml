/// @param buffer
/// @param EffectComponent

var buffer = argument0;
var component = argument1;

buffer_write(buffer, buffer_f32, component.light_x);
buffer_write(buffer, buffer_f32, component.light_y);
buffer_write(buffer, buffer_f32, component.light_z);
buffer_write(buffer, buffer_u32, component.light_colour);
buffer_write(buffer, buffer_f32, component.light_radius);