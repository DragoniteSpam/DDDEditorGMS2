/// @param buffer
/// @param EffectComponent
function serialize_save_entity_effect_com(argument0, argument1) {

    var buffer = argument0;
    var component = argument1;

    buffer_write(buffer, buffer_string, component.script_call);


}
