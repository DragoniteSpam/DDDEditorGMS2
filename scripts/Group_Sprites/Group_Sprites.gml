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
    var buffer = buffer_create(sw * sh * 4, buffer_fixed, 1);
    buffer_get_surface(buffer, surface, 0);
    surface_free(surface);
    return buffer;
}

function sprite_from_buffer(buffer, w, h) {
    var surface = surface_create(w, h);
    buffer_set_surface(buffer, surface, 0);
    var sprite = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_free(surface);
    return sprite;
}

function sprite_to_surface(sprite, subimg) {
    // https://www.yoyogames.com/blog/60/alpha-and-surfaces
    var sw = sprite_get_width(sprite);
    var sh = sprite_get_height(sprite);
    var t = surface_create(sw, sh);
    surface_set_target(t);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode(bm_add);
    gpu_set_blendenable(false);
    draw_sprite(sprite, subimg, 0, 0);
    gpu_set_blendmode(bm_normal);
    gpu_set_blendenable(true);
    surface_reset_target();
    return t;
}

function sprite_from_surface(surface) {
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    return sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
}