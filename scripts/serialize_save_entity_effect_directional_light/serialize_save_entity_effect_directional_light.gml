/// @param buffer
/// @param EntityEffectDirectionalLight

var buffer = argument0;
var effect = argument1;

serialize_save_entity_effect(buffer, effect);

buffer_write(buffer, buffer_u32, effect.light_colour);