/// @param buffer
/// @param EntityEffect
/// @param version
function serialize_load_entity_effect(argument0, argument1, argument2) {

    var buffer = argument0;
    var effect = argument1;
    var version = argument2;

    var map = Stuff.map.active_map;
    var map_contents = map.contents;

    serialize_load_entity(buffer, effect, version);

    var light_type = buffer_read(buffer, buffer_u8);
    switch (light_type) {
        case LightTypes.NONE: effect.com_light = undefined; break;
        case LightTypes.DIRECTIONAL: effect.com_light = new ComponentDirectionalLight(effect); break;
        case LightTypes.POINT: effect.com_light = new ComponentPointLight(effect); break;
        case LightTypes.SPOT: effect.com_light = new ComponentSpotLight(effect); break;
    }
    if (effect.com_light) {
        effect.com_light.load_script(buffer, effect.com_light, version);
    }

    var particle_type = buffer_read(buffer, buffer_u8);
    effect.com_particle = undefined;
    if (effect.com_particle) {
        effect.com_particle.parent = effect;
        effect.com_particle.load_script(buffer, effect.com_particle, version);
    }

    var audio_type = buffer_read(buffer, buffer_u8);
    effect.com_audio = undefined;
    if (effect.com_audio) {
        effect.com_audio.parent = effect;
        effect.com_audio.load_script(buffer, effect.com_audio, version);
    }

    entity_effect_position_colliders(effect);


}
