/// @param buffer
/// @param EntityEffect
function serialize_save_entity_effect(argument0, argument1) {

    var buffer = argument0;
    var effect = argument1;

    serialize_save_entity(buffer, effect);

    if (effect.com_light) {
        buffer_write(buffer, buffer_u8, effect.com_light.light_type);
        effect.com_light.save_script(buffer, effect.com_light);
    } else {
        buffer_write(buffer, buffer_u8, LightTypes.NONE);
    }

    if (effect.com_particle) {
        buffer_write(buffer, buffer_u8, effect.com_particle.particle_type);
        effect.com_particle.save_script(buffer, effect.com_particle);
    } else {
        buffer_write(buffer, buffer_u8, 0);
    }

    if (effect.com_audio) {
        buffer_write(buffer, buffer_u8, effect.com_audio.audio_type);
        effect.com_audio.save_script(buffer, effect.com_audio);
    } else {
        buffer_write(buffer, buffer_u8, 0);
    }


}
