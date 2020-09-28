/// @param UIButton
function ui_particle_reset(argument0) {

    var button = argument0;

    part_particles_clear(Stuff.particle.system);
    for (var i = 0; i < ds_list_size(Stuff.particle.emitters); i++) {
        instance_activate_object(Stuff.particle.emitters[| i]);
        instance_destroy(Stuff.particle.emitters[| i]);
    }
    for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
        instance_activate_object(Stuff.particle.types[| i]);
        instance_destroy(Stuff.particle.types[| i]);
    }
    ds_list_clear(Stuff.particle.emitters);
    ds_list_clear(Stuff.particle.types);


}
