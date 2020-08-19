/// @param UIButton
function ui_particle_save(argument0) {

    var button = argument0;

    var fn = get_save_filename("DDD Particle files|*" + EXPORT_EXTENSION_PARTICLES, "");
    if (fn == "") {
        return;
    }

    var fbuffer = buffer_create(1024, buffer_grow, 1);
    serialize_save_particles(fbuffer);
    buffer_save(fbuffer, fn);
    buffer_delete(fbuffer);


}
