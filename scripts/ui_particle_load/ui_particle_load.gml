/// @param UIButton
function ui_particle_load(argument0) {

	var button = argument0;

	var fn = get_open_filename("DDD Particle files|*" + EXPORT_EXTENSION_PARTICLES, "");
	if (!file_exists(fn)) {
	    return;
	}

	var fbuffer = buffer_load(fn);
	var version = buffer_peek(fbuffer, 0, buffer_u32);
	serialize_load_particles(fbuffer, version);
	buffer_delete(fbuffer);


}
