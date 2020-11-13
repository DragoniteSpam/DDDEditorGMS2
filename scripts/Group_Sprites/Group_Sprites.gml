#macro sprite_save sprite_save_fixed

function sprite_save_fixed(sprite, subimg, path) {
    // by yellowafterlife
    var t = sprite_to_surface(sprite, subimg);
    surface_save(t, path);
    surface_free(t);
}

function sprite_to_buffer(sprite, subimg) {
    // by yellowafterlife
    var surface = sprite_to_surface(sprite, subimg);
    var sw = sprite_get_width(sprite);
    var sh = sprite_get_height(sprite);
    var buffer = buffer_create(sw * sh * 4, buffer_fast, 1);
    buffer_get_surface(buffer, surface, 0);
    surface_free(surface);
    return buffer;
}

function sprite_to_surface(sprite, subimg) {
    // by yellowafterlife
    var sw = sprite_get_width(sprite);
    var sh = sprite_get_height(sprite);
    var t = surface_create(sw, sh);
    surface_set_target(t);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode(bm_add);
    draw_sprite(sprite, subimg, 0, 0);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    return t;
}