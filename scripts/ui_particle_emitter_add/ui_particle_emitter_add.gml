/// @param UIButton
function ui_particle_emitter_add(argument0) {

    var button = argument0;

    if (ds_list_size(Stuff.particle.emitters) < PART_MAXIMUM_EMITTERS) {
        var emitter = instance_create_depth(0, 0, 0, ParticleEmitter);
        emitter.name = "Emitter " + string(ds_list_size(Stuff.particle.emitters));
        instance_deactivate_object(emitter);
        ds_list_add(Stuff.particle.emitters, emitter);
    
        return emitter;
    }

    return noone;


}
