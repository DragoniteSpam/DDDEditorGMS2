function sprite_combine_grayscale_channels(r, g, b, w, h, bands_r = 255, bands_g = 255, bands_b = 255) {
    static sampler_red = shader_get_sampler_index(shd_utility_combine_channels, "samp_red");
    static sampler_green = shader_get_sampler_index(shd_utility_combine_channels, "samp_green");
    static sampler_blue = shader_get_sampler_index(shd_utility_combine_channels, "samp_blue");
    static uniform_scale_r = shader_get_uniform(shd_utility_combine_channels, "u_SpriteDataR");
    static uniform_scale_g = shader_get_uniform(shd_utility_combine_channels, "u_SpriteDataG");
    static uniform_scale_b = shader_get_uniform(shd_utility_combine_channels, "u_SpriteDataB");
    static pixel = undefined;
    
    if (pixel == undefined) {
        var s = surface_create(1, 1);
        surface_set_target(s);
        draw_clear(c_black);
        surface_reset_target();
        pixel = sprite_create_from_surface(s, 0, 0, 1, 1, false, false, 0, 0);
        surface_free(s);
    }
    
    var wr = sprite_get_width(r);
    var hr = sprite_get_height(r);
    var wg = sprite_get_width(g);
    var hg = sprite_get_height(g);
    var wb = sprite_get_width(b);
    var hb = sprite_get_height(b);
    
    var shader = shader_current();
    shader_set(shd_utility_combine_channels);
    shader_set_uniform_f(uniform_scale_r, wr / ceil_power_of_two(wr), hr / ceil_power_of_two(hr), bands_r);
    shader_set_uniform_f(uniform_scale_g, wg / ceil_power_of_two(wg), hg / ceil_power_of_two(hg), bands_g);
    shader_set_uniform_f(uniform_scale_b, wb / ceil_power_of_two(wb), hb / ceil_power_of_two(hb), bands_b);
    texture_set_stage(sampler_red, sprite_get_texture(sprite_exists(r) ? r : pixel, 0));
    texture_set_stage(sampler_green, sprite_get_texture(sprite_exists(g) ? g : pixel, 0));
    texture_set_stage(sampler_blue, sprite_get_texture(sprite_exists(b) ? b : pixel, 0));
    draw_sprite_stretched(pixel, 0, 0, 0, w, h);
    shader_set(shader);
}