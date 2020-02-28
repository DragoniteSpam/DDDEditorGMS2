/// @param buffer
/// @param EntityEffect
/// @param version

var buffer = argument0;
var effect = argument1;
var version = argument2;

var map = Stuff.map.active_map;
var map_contents = map.contents;

serialize_load_entity(buffer, effect, version);

var light_type = buffer_read(buffer, buffer_u8);
switch (light_type) {
    case LightTypes.NONE: effect.com_light = noone; break;
    case LightTypes.DIRECTIONAL: effect.com_light = instance_create_depth(0, 0, 0, EffectComponentDirectionalLight); break;
    case LightTypes.POINT: effect.com_light = instance_create_depth(0, 0, 0, EffectComponentPointLight); break;
    case LightTypes.SPOT: effect.com_light = noone; break;
}
if (effect.com_light) {
    effect.com_light.parent = effect;
    script_execute(effect.com_light.load_script, buffer, effect.com_light, version);
    // for now, anyway
    for (var i = 0; i < MAX_LIGHTS; i++) {
        if (!refid_get(map_contents.active_lights[| i])) {
            map_contents.active_lights[| i] = effect.REFID;
            break;
        }
    }
}

var particle_type = buffer_read(buffer, buffer_u8);
effect.com_particle = noone;
if (effect.com_particle) {
    effect.com_particle.parent = effect;
    script_execute(effect.com_particle.load_script, buffer, effect.com_particle, version);
}

var audio_type = buffer_read(buffer, buffer_u8);
effect.com_audio = noone;
if (effect.com_audio) {
    effect.com_audio.parent = effect;
    script_execute(effect.com_audio.load_script, buffer, effect.com_audio, version);
}