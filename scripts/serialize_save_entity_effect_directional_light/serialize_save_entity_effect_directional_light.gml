/// @param buffer
/// @param EntityEffectDirectionalLight

var buffer = argument0;
var effect = argument1;

serialize_save_entity_effect(buffer, effect);

buffer_write(buffer, buffer_f32, effect.light_x);
buffer_write(buffer, buffer_f32, effect.light_y);
buffer_write(buffer, buffer_f32, effect.light_z);
buffer_write(buffer, buffer_f32, effect.light_dx);
buffer_write(buffer, buffer_f32, effect.light_dy);
buffer_write(buffer, buffer_f32, effect.light_dz);
buffer_write(buffer, buffer_u32, effect.light_colour);