/// @param buffer
/// @param EffectComponent
/// @param version
function serialize_load_entity_effect_com(argument0, argument1, argument2) {

	var buffer = argument0;
	var component = argument1;
	var version = argument2;

	component.script_call = buffer_read(buffer, buffer_string);


}
