/// @param buffer
/// @param EffectComponent
/// @param version
function serialize_load_entity_effect_com_directional_light(argument0, argument1, argument2) {

	var buffer = argument0;
	var component = argument1;
	var version = argument2;

	serialize_load_entity_effect_com(buffer, component, version);

	component.light_dx = buffer_read(buffer, buffer_f32);
	component.light_dy = buffer_read(buffer, buffer_f32);
	component.light_dz = buffer_read(buffer, buffer_f32);
	component.light_colour = buffer_read(buffer, buffer_u32);


}
