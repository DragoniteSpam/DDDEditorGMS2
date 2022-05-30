function sprite_combine_grayscale_channels(r, g, b) {
    static sampler_green = shader_get_sampler_index(shd_utility_combine_channels, "samp_green");
    static sampler_blue = shader_get_sampler_index(shd_utility_combine_channels, "samp_blue");
    
    var w = sprite_get_width(r);
    var h = sprite_get_height(r);
    var surface = surface_create(w, h);
    var shader = shader_current();
    shader_set(shd_utility_combine_channels);
    texture_set_stage(sampler_green, sprite_get_texture(g, 0));
    texture_set_stage(sampler_blue, sprite_get_texture(b, 0));
    
    surface_set_target(surface);
    draw_clear(c_black);
    draw_sprite(r, 0, 0, 0);
    surface_reset_target();
    shader_set(shader);
    
    var sprite = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_free(surface);
    
    return sprite;
}