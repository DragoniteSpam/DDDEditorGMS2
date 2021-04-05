#macro sprite_save sprite_save_fixed
#macro __sprite_add_old sprite_add
#macro sprite_add sprite_add_fixed

function sprite_add_fixed(filename, imagenum, removeback, smooth, xorig, yorig) {
    var sprite = __sprite_add_old(filename, imagenum, false, false, xorig, yorig);
    
    if (removeback) {
        var buffer = sprite_to_buffer(sprite, 0);
        var sh = sprite_get_height(sprite);
        var sw = sprite_get_width(sprite);
        var addr_remove = (sh - 1) * sw * buffer_sizeof(buffer_u32);
        var color_remove = buffer_peek(buffer, addr_remove, buffer_u32) & 0x00ffffff;
        for (var i = 0; i < sw * sh; i++) {
            var addr = i * buffer_sizeof(buffer_u32);
            if ((buffer_peek(buffer, addr, buffer_u32) & 0x00ffffff) == color_remove) {
                buffer_poke(buffer, addr, buffer_u32, 0x00000000);
            }
        }
        sprite_delete(sprite);
        sprite = sprite_from_buffer(buffer, sw, sh);
    }
    
    return sprite;

}

function sprite_save_fixed(sprite, subimg, path) {
    // by yellowafterlife
    var t = sprite_to_surface(sprite, subimg);
    surface_save(t, path);
    surface_free(t);
}

function sprite_to_buffer(sprite, subimg) {
    // by yellowafterlife
    var surface = sprite_to_surface(sprite, subimg);
    var buffer = buffer_create(sprite_get_width(sprite) * sprite_get_height(sprite) * 4, buffer_fixed, 1);
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
    var t = surface_create(sprite_get_width(sprite), sprite_get_height(sprite));
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
    return sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_height(surface), false, false, 0, 0);
}