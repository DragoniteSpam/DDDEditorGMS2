function draw_editor_terrain() {
    Stuff.terrain.DrawDepth();
    
    draw_set_color(c_white);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(true);
    
    self.camera.SetProjection();
    if (Settings.terrain.view_skybox) {
        self.camera.DrawSkybox();
    }
    
    if (Settings.terrain.orthographic) {
        self.camera.SetProjectionOrtho();
    } else {
        self.camera.SetProjection();
    }
    
    shader_set(shd_terrain);
    // lighting uniforms
    Settings.terrain.light_direction = Settings.terrain.light_direction.Normalize();
    var secondary = Settings.terrain.light_direction.Rotate(new Vector3(0, 0, 1), 120);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightAmbientColor"), Settings.terrain.light_ambient.r, Settings.terrain.light_ambient.g, Settings.terrain.light_ambient.b);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightDirection"), -Settings.terrain.light_direction.x, -Settings.terrain.light_direction.y, -Settings.terrain.light_direction.z, 1);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightDirectionSecondary"), -secondary.x, -secondary.y, -secondary.z, 0.25);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightShadows"), Settings.terrain.light_shadows);
    
    shader_set_uniform_f_array(shader_get_uniform(shd_terrain, "u_LightVP"), self.camera_light.GetVPMatrix() ?? matrix_build_identity());
    gpu_set_tex_filter_ext(shader_get_sampler_index(shd_terrain, "s_DepthTexture"), true);
    texture_set_stage(shader_get_sampler_index(shd_terrain, "s_DepthTexture"), surface_get_texture(self.depth_surface));
    
    texture_set_stage(shader_get_sampler_index(shd_terrain, "s_ShadingGradient"), sprite_get_texture(self.gradient_images[Settings.terrain.gradient_image], 0));
    // fog uniforms
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStrength"), Settings.terrain.fog_enabled * !Settings.terrain.orthographic ? 1 : 0);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStart"), Settings.terrain.fog_start);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogEnd"), Settings.terrain.fog_end);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogColor"), (Settings.terrain.fog_color & 0x0000ff) / 0xff, ((Settings.terrain.fog_color & 0x00ff00) >> 8) / 0xff, ((Settings.terrain.fog_color & 0xff0000) >> 16) / 0xff);
    // wireframe uniforms
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WireAlpha"), Settings.terrain.wireframe_alpha);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WireColor"), 1, 1, 1);
    // water uniforms
    var water_level = 512 * power(Settings.terrain.water_level, 3);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterLevels"), water_level - 320, water_level, 0.75 * Settings.terrain.view_water);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterColor"), 0.1, 0.1, 0.6);
    // terrain stuff
    matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "terrainSize"), Stuff.terrain.width, Stuff.terrain.height);
    // editor cursor stuff
    var xx = Stuff.terrain.cursor_position ? Stuff.terrain.cursor_position.x : 0;
    var yy = Stuff.terrain.cursor_position ? Stuff.terrain.cursor_position.y : 0;
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_Mouse"), xx, yy, self.GetCurrentBrushRadius(), Stuff.terrain.cursor_position ? Settings.terrain.cursor_alpha : 0);
    texture_set_stage(shader_get_sampler_index(shd_terrain, "u_CursorTexture"), self.GetCurrentBrushTexture());
    // color stuff
    texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexColor"), surface_get_texture(Stuff.terrain.color.surface));
    // texture stuff
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TextureTileSize"), sprite_get_width(Stuff.terrain.texture_image) / Settings.terrain.tile_brush_size, sprite_get_height(Stuff.terrain.texture_image) / Settings.terrain.tile_brush_size);
    // because gamemaker doesnt like sharing uniforms between vertex and fragment shader apparently
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainSizeV"), Stuff.terrain.width, Stuff.terrain.height);
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainSizeF"), Stuff.terrain.width, Stuff.terrain.height);
    gpu_set_texfilter_ext(shader_get_sampler_index(shd_terrain, "u_TexLookup"), false);
    texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexLookup"), surface_get_texture(Stuff.terrain.texture.surface));
    // other stuff
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_OptViewData"), Settings.terrain.view_data);
    
    var cutoff = Settings.terrain.view_distance;
    var chunk_angle = dcos(Settings.terrain.camera.fov * 1.5);
    for (var i = 0, n = array_length(Stuff.terrain.terrain_buffers); i < n; i++) {
        var position = self.GetTerrainBufferPositionWorld(i);
        var chunk_distance = self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2);
        
        if (chunk_distance >= TERRAIN_INTERNAL_CHUNK_SIZE && self.camera.Dot2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2) <= chunk_angle) continue;
        
        var use_lod_zero = chunk_distance <= cutoff;
        
        var neighbor_use_lod_zero =
            (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
            (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
            (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
            (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff);
        
        if (neighbor_use_lod_zero || use_lod_zero) {
            vertex_submit(Stuff.terrain.terrain_buffers[i], pr_trianglelist, sprite_get_texture(Stuff.terrain.texture_image, 0));
            self.stats.chunks.full++;
            self.stats.triangles += vertex_get_number(Stuff.terrain.terrain_buffers[i]);
        }
        if (!use_lod_zero) {
            vertex_submit(Stuff.terrain.terrain_lods[i], pr_trianglelist, sprite_get_texture(Stuff.terrain.texture_image, 0));
            self.stats.chunks.lod++;
            self.stats.triangles += vertex_get_number(Stuff.terrain.terrain_lods[i]);
        }
    }
    
    if (Settings.terrain.view_axes) {
        matrix_set(matrix_world, matrix_build(0, 0, 1, 0, 0, 0, 0.5, 0.5, 0.5));
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes, pr_trianglelist, -1);
    }
    
    Stuff.terrain.DrawWater();
    
    shader_reset();
    
    matrix_set(matrix_world, matrix_build_identity());
}