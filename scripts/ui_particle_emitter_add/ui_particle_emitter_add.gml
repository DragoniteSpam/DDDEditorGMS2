/// @param UIButton
function ui_particle_emitter_add(argument0) {

    var button = argument0;

    if (array_length(Stuff.particle.emitters) < PART_MAXIMUM_EMITTERS) {
        array_push(Stuff.particle.emitters, new ParticleEmitter("Emitter " + string(array_length(Stuff.particle.emitters))));
    }

    return noone;


}
