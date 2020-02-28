/// @param buffer
/// @param EntityEffect
/// @param version

var buffer = argument0;
var effect = argument1;
var version = argument2;

serialize_load_entity(buffer, effect, version);

effect.light_colour = buffer_read(buffer, buffer_u32);
effect.light_radius = buffer_read(buffer, buffer_f32);

// remember to add collision information - probably in the form of a block or sphere