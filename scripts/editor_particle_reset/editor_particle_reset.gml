function editor_particle_reset() {
    part_particles_clear(Stuff.particle.system);
    array_resize(Stuff.particle.emitters, 0);
    array_resize(Stuff.particle.types, 0);
}