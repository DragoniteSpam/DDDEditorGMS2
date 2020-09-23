function ui_particle_export_code(button) {
    var fn = get_save_filename_gml("particles.gml");
    if (fn == "") return;
    
    var text = editor_particle_generate_code();
    var fbuffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(fbuffer, buffer_text, text);
    buffer_save(fbuffer, fn);
    buffer_delete(fbuffer);
}