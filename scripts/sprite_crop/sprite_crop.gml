function sprite_crop(sprite, x, y, w, h) {
    var surface = surface_create(w, h);
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode(bm_add);
    draw_sprite(sprite, 0, -x, -y);
    gpu_set_blendmode(bm_normal);
    var cropped = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_reset_target();
    surface_free(surface);
    return cropped;
}