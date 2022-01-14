function draw_editor_terrain() {
    draw_set_color(c_white);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(true);
    
    self.camera.SetProjection();
    self.camera.DrawSkybox();
    
    if (Settings.terrain.orthographic) {
        self.camera.SetProjectionOrtho();
    } else {
        self.camera.SetProjection();
    }
    
    shader_set(shd_terrain);
    // lighting uniforms
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightAmbientColor"), 0.25, 0.25, 0.25);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightDirection"), 1, 1, -1);
    // fog uniforms
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStrength"), Settings.terrain.fog_enabled ? 1 : 0);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStart"), Settings.terrain.fog_start);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogEnd"), Settings.terrain.fog_end);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogColor"), (Settings.terrain.fog_color & 0x0000ff) / 0xff, ((Settings.terrain.fog_color & 0x00ff00) >> 8) / 0xff, ((Settings.terrain.fog_color & 0xff0000) >> 16) / 0xff);
    // wireframe uniforms
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WireThickness"), Settings.terrain.view_grid ? 1 : 0);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WireColor"), 1, 1, 1);
    // water uniforms
    var water_level = 512 * power(Settings.terrain.water_level, 3) / Settings.terrain.view_scale;
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterLevels"), water_level - 64, water_level, 0.75 * Settings.terrain.view_water);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterColor"), 0.1, 0.1, 1);
    // terrain stuff
    matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, Settings.terrain.view_scale, Settings.terrain.view_scale, Settings.terrain.view_scale));
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "terrainSize"), Stuff.terrain.width, Stuff.terrain.height);
    // editor stuff
    if (!Stuff.terrain.cursor_position || !Settings.terrain.view_cursor) {
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_Mouse"), -MILLION, -MILLION);
    } else {
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_Mouse"), Stuff.terrain.cursor_position.x, Stuff.terrain.cursor_position.y);
    }
    texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexColor"), surface_get_texture(Stuff.terrain.color.surface));
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_MouseRadius"), Settings.terrain.radius);
    
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TextureTileSize"), sprite_get_width(Stuff.terrain.texture_image) / 32, sprite_get_height(Stuff.terrain.texture_image) / 32);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainSize"), Stuff.terrain.texture.width, Stuff.terrain.texture.height);
    gpu_set_texfilter_ext(shader_get_sampler_index(shd_terrain, "u_TexLookup"), false);
    texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexLookup"), surface_get_texture(Stuff.terrain.texture.surface));
    // other options
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_OptViewNormals"), Settings.terrain.view_normals);
    
    vertex_submit(Stuff.terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(Stuff.terrain.texture_image, 0));
    
    if (Settings.terrain.view_axes) {
        matrix_set(matrix_world, matrix_build(0, 0, 1, 0, 0, 0, 2, 2, 2));
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes, pr_trianglelist, -1);
    }
    
    Stuff.terrain.DrawWater();
    
    shader_reset();
    
    matrix_set(matrix_world, matrix_build_identity());
}