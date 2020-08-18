/// @param emitter
function editor_particle_emitter_set_region(argument0) {

	var emitter = argument0;
	part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, emitter.region_shape, emitter.region_distribution);


}
