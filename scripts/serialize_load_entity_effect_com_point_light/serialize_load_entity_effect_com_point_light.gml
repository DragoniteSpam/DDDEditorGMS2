/// @param buffer
/// @param EffectComponent
/// @param version

var buffer = argument0;
var component = argument1;
var version = argument2;

component.light_x = buffer_read(buffer, buffer_f32);
component.light_y = buffer_read(buffer, buffer_f32);
component.light_z = buffer_read(buffer, buffer_f32);
component.light_colour = buffer_read(buffer, buffer_u32);
component.light_radius = buffer_read(buffer, buffer_f32);