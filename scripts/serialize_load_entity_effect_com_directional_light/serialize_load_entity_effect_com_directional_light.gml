/// @param buffer
/// @param EffectComponent
/// @param version

var buffer = argument0;
var component = argument1;
var version = argument2;

component.light_dx = buffer_read(buffer, buffer_f32);
component.light_dy = buffer_read(buffer, buffer_f32);
component.light_dz = buffer_read(buffer, buffer_f32);
component.light_colour = buffer_read(buffer, buffer_u32);