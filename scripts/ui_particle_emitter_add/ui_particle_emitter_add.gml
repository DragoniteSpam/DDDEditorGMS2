/// @param UIButton
function ui_particle_emitter_add(argument0) {

    var button = argument0;

    if (array_length(Stuff.particle.emitters) < PART_MAXIMUM_EMITTERS) {
        var emitter = instance_create_depth(0, 0, 0, ParticleEmitter);
        emitter.name = "Emitter " + string(array_length(Stuff.particle.emitters));
        instance_deactivate_object(emitter);
        array_push(Stuff.particle.emitters, emitter);
    
        return emitter;
    }

    return noone;


}
