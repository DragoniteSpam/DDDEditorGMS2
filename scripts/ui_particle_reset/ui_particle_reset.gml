/// @param UIButton

var button = argument0;

part_particles_clear(Stuff.particle.system);
for (var i = 0; i < ds_list_size(Stuff.particle.emitters); i++) {
    part_emitter_destroy(Stuff.particle.system, Stuff.particle.emitters[| i]);
}
for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
    part_emitter_destroy(Stuff.particle.system, Stuff.particle.types[| i]);
}
ds_list_clear(Stuff.particle.emitters);
ds_list_clear(Stuff.particle.types);