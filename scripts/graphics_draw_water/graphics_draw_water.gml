function graphics_draw_water(set_lights = true) {
    var map = Stuff.map.active_map;
    if (!map.draw_water) return;
    
    var modulo = Stuff.graphics.water_reptition;
    var s = Stuff.graphics.water_tile_size;
    var base_x = round_ext(Stuff.map.x, s);
    var base_y = round_ext(Stuff.map.y, s);
    
    if (map.contents.water) {
        matrix_set(matrix_world, matrix_build_identity());
        var tex = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        vertex_submit(map.contents.water, pr_trianglelist, tex);
    }
    
    return;
    
    // This is the old water rendering, we may not keep it
    for (var i = -1; i < 3; i++) {
        for (var j = -1; j < 3; j++) {
            matrix_set(matrix_world, matrix_build(i * s + base_x, j * s + base_y, map.water_level * TILE_DEPTH, 0, 0, 0, 1, 1, 1));
            texture_set_stage(shader_get_sampler_index(shd_water, "displacementMap"), sprite_get_texture(spr_water_displacement, 0));
            shader_set_uniform_f(shader_get_uniform(shd_water, "displacement"), 0.0625);
            shader_set_uniform_f(shader_get_uniform(shd_water, "baseAlpha"), 0.25);
            shader_set_uniform_f(shader_get_uniform(shd_water, "time"), current_time / 1000, current_time / 1000);
            
            vertex_submit(Stuff.graphics.mesh_water_base, pr_trianglelist, sprite_get_texture(spr_water_base, 0));
            
            shader_set_uniform_f(shader_get_uniform(shd_water, "baseAlpha"), 0.75);
            shader_set_uniform_f(shader_get_uniform(shd_water, "time"), current_time / 1024, current_time / 1200);
            vertex_submit(Stuff.graphics.mesh_water_bright, pr_trianglelist, sprite_get_texture(spr_water_base, 0));
        }
    }
    
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
}