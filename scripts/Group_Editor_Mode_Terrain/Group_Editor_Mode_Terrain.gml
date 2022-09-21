#macro TERRAIN_GEN_SPRITE_INDEX_MUTATE                                          0
#macro TERRAIN_GEN_SPRITE_INDEX_BRUSH                                           1
#macro TERRAIN_GEN_SPRITE_INDEX_TEXTURE                                         2

function EditorModeTerrain() : EditorModeBase() constructor {
    debug_timer_start();
    
    Stuff.terrain = self;
    
    self.stats = {
        chunks: {
            full: 0,
            lod: 0,
        },
        triangles: 0,
    };
    
    vertex_format_begin();
    vertex_format_add_position_3d();
    self.vertex_format = vertex_format_end();
    
    self.EditModeZ = function(position, dir) {
        var r = Settings.terrain.radius;
        var damping = (Settings.terrain.submode == TerrainSubmodes.AVERAGE) ? 0.25 : 1;
        terrainops_deform_settings(self.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH, position.x, position.y, r, dir * Settings.terrain.rate * damping);
    
        switch (Settings.terrain.submode) {
            case TerrainSubmodes.MOUND: terrainops_deform_mold(); break;
            case TerrainSubmodes.AVERAGE: terrainops_deform_average(); break;
            case TerrainSubmodes.ZERO: terrainops_deform_zero(); break;
        }
    
        self.RegenerateTerrainBufferRange(position.x - r, position.y - r, position.x + r, position.y + r);
    }
    
    self.EditModeTexture = function(position) {
        var color_code = self.GetTextureColorCode();
        self.texture.Paint(position.x, position.y, Settings.terrain.tile_brush_radius, color_code, 1);
    };
    
    self.EditModeColor = function(position) {
        var csx = surface_get_width(self.color.surface) / self.width;
        var csy = surface_get_height(self.color.surface) / self.height;
        self.color.Paint(position.x * csx, position.y * csy, Settings.terrain.paint_brush_radius * max(csx, csy), Settings.terrain.paint_color, Settings.terrain.paint_strength);
    };
    
    self.mouse_interaction = function(mouse_vector) {
        self.cursor_position = undefined;
    
        if (mouse_vector.direction.z < mouse_vector.origin.z) {
            var f = abs(mouse_vector.origin.z / mouse_vector.direction.z);
            self.cursor_position = new Vector2(mouse_vector.origin.x + mouse_vector.direction.x * f, mouse_vector.origin.y + mouse_vector.direction.y * f);
        
            if (Controller.mouse_left) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: self.EditModeZ(self.cursor_position, 1); break;
                    case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                    case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
                }
            }
        
            if (Controller.mouse_right) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: self.EditModeZ(self.cursor_position, -1); break;
                    case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                    case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
                }
            }
        
            if (Controller.release_right) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: break;
                    case TerrainModes.TEXTURE: self.texture.Finish(); break;
                    case TerrainModes.COLOR: self.color.Finish(); break;
                }
            }
        
            if (Controller.release_left) {
                switch (Settings.terrain.mode) {
                    case TerrainModes.Z: break;
                    case TerrainModes.TEXTURE: self.texture.Finish(); break;
                    case TerrainModes.COLOR: self.color.Finish(); break;
                }
            }
        }
    
        if (keyboard_check_pressed(vk_space)) {
    
        }
    
        if (keyboard_check_pressed(vk_delete)) {
    
        }
    }
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.TERRAIN);
    };
    
    self.Update = function() {
        self.texture.Validate();
        self.color.Validate();
        
        self.stats.chunks.full = 0;
        self.stats.chunks.lod = 0;
        self.stats.triangles = 0;
        
        // you only get the keyboard shortcuts if we're running under the terrain config
        if (IS_TERRAIN_MODE) {
            if (keyboard_check(vk_control)) {
                if (keyboard_check_pressed(ord("S"))) {
                    momu_terrain_save();
                }
                else if (keyboard_check_pressed(ord("O"))) {
                    momu_terrain_load();
                }
                else if (keyboard_check_pressed(ord("E"))) {
                    if (keyboard_check(vk_shift)) {
                        momu_terrain_heightmap();
                    } else {
                        momu_terrain_export();
                    }
                }
                else if (keyboard_check_pressed(ord("N"))) {
                    momu_terrain_new();
                }
            }
        }
        
        if (Stuff.menu.active_element || !ds_list_empty(EmuOverlay._contents)) return;
        
        // the regular camera is updated in the render surface's update method
        self.camera_light.Update();
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        self.ui.Render(0, 0);
        editor_gui_post();
    };
    
    self.Save = function() {
        Settings.terrain.camera = self.camera.Save();
        Settings.terrain.camera_light = self.camera_light.Save();
    };
    
    enum TerrainViewData {
        DIFFUSE, POSITION, NORMAL, DEPTH, BARYCENTRIC,
    }
    
    #region
    self.gen_sprites = [
        { sprite: spr_terrain_gen_flat, name: "Square", builtin: true, },
        { sprite: spr_terrain_gen_dot, name: "Circle", builtin: true, },
        { sprite: spr_terrain_gen_bullseye, name: "Bullseye", builtin: true, },
        { sprite: spr_terrain_gen_mountain, name: "Mountain", builtin: true, },
        { sprite: spr_terrain_gen_craters, name: "Craters", builtin: true, },
        { sprite: spr_terrain_gen_drago, name: "Drago", builtin: true, },
        { sprite: spr_terrain_gen_juju, name: "Juju", builtin: true, },
    ];
    
    self.brush_sprites = array_clone(self.gen_sprites);
    
    array_push(self.brush_sprites,
        { sprite: spr_terrain_gen_part_disc, name: "Disc", builtin: true, },
        { sprite: spr_terrain_gen_part_star, name: "Star", builtin: true, },
        { sprite: spr_terrain_gen_part_circle, name: "Circle", builtin: true, },
        { sprite: spr_terrain_gen_part_ring, name: "Ring", builtin: true, },
        { sprite: spr_terrain_gen_part_sphere, name: "Sphere", builtin: true, },
        { sprite: spr_terrain_gen_part_flare, name: "Flare", builtin: true, },
        { sprite: spr_terrain_gen_part_spark, name: "Spark", builtin: true, },
        { sprite: spr_terrain_gen_part_explosion, name: "Explosion", builtin: true, },
        { sprite: spr_terrain_gen_part_cloud, name: "Cloud", builtin: true, },
        { sprite: spr_terrain_gen_part_smoke, name: "Smoke", builtin: true, },
        { sprite: spr_terrain_gen_part_snow, name: "Snow", builtin: true, },
    );
    
    // general editing settings
    Settings.terrain.color_scale = Settings.terrain[$ "color_scale"] ?? TERRAIN_DEF_COLOR_SCALE;
    // import and export settings
    Settings.terrain.gen_noise_scale = Settings.terrain[$ "gen_noise_scale"] ?? TERRAIN_DEF_GEN_NOISE_SCALE;
    Settings.terrain.gen_noise_smoothness = Settings.terrain[$ "gen_noise_smoothness"] ?? TERRAIN_DEF_GEN_NOISE_SMOOTHNESS;
    Settings.terrain.heightmap_scale = Settings.terrain[$ "heightmap_scale"] ?? TERRAIN_DEF_HEIGHTMAP_SCALE;
    Settings.terrain.save_scale = Settings.terrain[$ "save_scale"] ?? TERRAIN_DEF_EXPORT_SCALE;
    Settings.terrain.export_all = Settings.terrain[$ "export_all"] ?? TERRAIN_DEF_EXPORT_ALL;
    Settings.terrain.export_swap_uvs = Settings.terrain[$ "export_swap_uvs"] ?? TERRAIN_DEF_EXPORT_SWAP_UVS;
    Settings.terrain.export_swap_zup = Settings.terrain[$ "export_swap_zup"] ?? TERRAIN_DEF_EXPORT_SWAP_ZUP;
    Settings.terrain.export_centered = Settings.terrain[$ "export_centered"] ?? TERRAIN_DEF_EXPORT_CENTERED;
    Settings.terrain.export_chunk_size = Settings.terrain[$ "export_chunk_size"] ?? TERRAIN_DEF_EXPORT_CHUNK_SIZE;
    Settings.terrain.export_smooth = Settings.terrain[$ "export_smooth"] ?? TERRAIN_DEF_EXPORT_SMOOTH;
    Settings.terrain.export_smooth_threshold = Settings.terrain[$ "export_smooth_threshold"] ?? TERRAIN_DEF_EXPORT_SMOOTH_THRESHOLD;
    Settings.terrain.export_lod_levels = Settings.terrain[$ "export_lod_levels"] ?? TERRAIN_DEF_EXPORT_LOD_LEVELS;
    Settings.terrain.export_lod_reduction = Settings.terrain[$ "export_lod_reduction"] ?? TERRAIN_DEF_EXPORT_LOD_REDUCTION;
    Settings.terrain.output_vertex_format = Settings.terrain[$ "output_vertex_format"] ?? TERRAIN_DEF_EXPORT_VERTEX_FORMAT;
    // viewer settings
    Settings.terrain.view_water = Settings.terrain[$ "view_water"] ?? TERRAIN_DEF_VIEW_WATER;
    Settings.terrain.view_water_min_alpha = Settings.terrain[$ "view_water_min_alpha"] ?? TERRAIN_DEF_WATER_MIN_ALPHA;
    Settings.terrain.view_water_max_alpha = Settings.terrain[$ "view_water_max_alpha"] ?? TERRAIN_DEF_WATER_MAX_ALPHA;
    Settings.terrain.water_level = Settings.terrain[$ "water_level"] ?? TERRAIN_DEF_WATER_LEVEL;
    Settings.terrain.view_distance = Settings.terrain[$ "view_distance"] ?? TERRAIN_DEF_VIEW_DISTANCE;
    Settings.terrain.wireframe_alpha = Settings.terrain[$ "wireframe_alpha"] ?? TERRAIN_DEF_WIREFRAME_ALPHA;
    Settings.terrain.cursor_alpha = Settings.terrain[$ "cursor_alpha"] ?? TERRAIN_DEF_CURSOR_ALPHA;
    Settings.terrain.view_skybox = Settings.terrain[$ "view_skybox"] ?? TERRAIN_DEF_VIEW_SKYBOX;
    Settings.terrain.view_axes = Settings.terrain[$ "view_axes"] ?? TERRAIN_DEF_VIEW_AXES;
    Settings.terrain.view_data = Settings.terrain[$ "view_data"] ?? TERRAIN_DEF_VIEW_DATA;
    Settings.terrain.orthographic = Settings.terrain[$ "orthographic"] ?? TERRAIN_DEF_ORTHOGRAPHIC;
    Settings.terrain.light_enabled = Settings.terrain[$ "light_enabled"] ?? TERRAIN_DEF_LIGHT_ENABLED;
    Settings.terrain.fog_enabled = Settings.terrain[$ "fog_enabled"] ?? TERRAIN_DEF_FOG_ENABLED;
    Settings.terrain.fog_color = Settings.terrain[$ "fog_color"] ?? TERRAIN_DEF_FOG_COLOR;
    Settings.terrain.fog_start = Settings.terrain[$ "fog_start"] ?? TERRAIN_DEF_FOG_START;
    Settings.terrain.fog_end = Settings.terrain[$ "fog_end"] ?? TERRAIN_DEF_FOG_END;
    Settings.terrain.gradient_image = Settings.terrain[$ "gradient_image"] ?? TERRAIN_DEF_GRADIENT;
    
    Settings.terrain.view_distance_ortho_min = Settings.terrain[$ "view_distance_ortho_min"] ?? TERRAIN_DEF_VIEW_DISTANCE_ORTHO_MIN;
    Settings.terrain.view_distance_ortho_max = Settings.terrain[$ "view_distance_ortho_max"] ?? TERRAIN_DEF_VIEW_DISTANCE_ORTHO_MAX;
    Settings.terrain.view_distance_perspective_min = Settings.terrain[$ "view_distance_perspective_min"] ?? TERRAIN_DEF_VIEW_DISTANCE_PERSPECTIVE_MIN;
    Settings.terrain.view_distance_perspective_max = Settings.terrain[$ "view_distance_perspective_max"] ?? TERRAIN_DEF_VIEW_DISTANCE_PERSPECTIVE_MAX;
    
    Settings.terrain.highlight_upwards_surfaces = Settings.terrain[$ "highlight_upwards_surfaces"] ?? TERRAIN_DEF_HIGHLIGHT_UPWARDS_SURFACES;
    Settings.terrain.highlight_upwards_angle = Settings.terrain[$ "highlight_upwards_angle"] ?? TERRAIN_DEF_HIGHLIGHT_UPWARDS_ANGLE;
    // light settings
    Settings.terrain.light_ambient_colour = Settings.terrain[$ "light_ambient_colour"] ?? TERRAIN_DEF_LIGHT_AMBIENT_COLOUR;
    Settings.terrain.light_primary_angle = Settings.terrain[$ "light_primary_angle"] ?? TERRAIN_DEF_LIGHT_PRIMARY_ANGLE;
    Settings.terrain.light_primary_strength = Settings.terrain[$ "light_primary_strength"] ?? TERRAIN_DEF_LIGHT_PRIMARY_STRENGTH;
    Settings.terrain.light_secondary_angle = Settings.terrain[$ "light_secondary_angle"] ?? TERRAIN_DEF_LIGHT_SECONDARY_ANGLE;
    Settings.terrain.light_secondary_strength = Settings.terrain[$ "light_secondary_strength"] ?? TERRAIN_DEF_LIGHT_SECONDARY_STRENGTH;
    Settings.terrain.light_shadows = Settings.terrain[$ "light_shadows"] ?? TERRAIN_DEF_LIGHT_SHADOWS;
    Settings.terrain.light_shadows_quality = Settings.terrain[$ "light_shadows_quality"] ?? TERRAIN_DEF_LIGHT_SHADOWS_QUALITY;
    Settings.terrain.light_direction = TERRAIN_DEF_LIGHT_DIRECTION;
    // height settings
    Settings.terrain.mode = TERRAIN_DEF_MODE;
    Settings.terrain.brush_min = TERRAIN_DEF_HEIGHT_BRUSH_MIN;
    Settings.terrain.brush_max = TERRAIN_DEF_HEIGHT_BRUSH_MAX;
    Settings.terrain.rate_min = TERRAIN_DEF_HEIGHT_RATE_MIN;
    Settings.terrain.rate_max = TERRAIN_DEF_HEIGHT_RATE_MAX;
    Settings.terrain.rate = Settings.terrain[$ "rate"] ?? TERRAIN_DEF_HEIGHT_RATE;
    Settings.terrain.brush_index = clamp(Settings.terrain[$ "brush_index"] ?? TERRAIN_DEF_HEIGHT_BRUSH_INDEX, 0, array_length(self.brush_sprites) - 1);
    Settings.terrain.radius = Settings.terrain[$ "radius"] ?? TERRAIN_DEF_HEIGHT_RADIUS;
    Settings.terrain.submode = TERRAIN_DEF_HEIGHT_SUBMODE;
    Settings.terrain.global_scale = Settings.terrain[$ "global_scale"] ?? TERRAIN_DEF_HEIGHT_GLOBAL_SCALE;
    // texture settings
    Settings.terrain.tile_brush_min = TERRAIN_DEF_TEX_BRUSH_MIN;
    Settings.terrain.tile_brush_max = TERRAIN_DEF_TEX_BRUSH_MAX;
    Settings.terrain.tile_brush_size_min = TERRAIN_DEF_TEX_BRUSH_SIZE_MIN;
    Settings.terrain.tile_brush_size_max = TERRAIN_DEF_TEX_BRUSH_SIZE_MAX;
    Settings.terrain.tile_brush_radius = Settings.terrain[$ "tile_brush_radius"] ?? TERRAIN_DEF_TEX_BRUSH_RADIUS;
    Settings.terrain.tile_brush_index = clamp(Settings.terrain[$ "tile_brush_index"] ?? TERRAIN_DEF_TEX_BRUSH_INDEX, 0, array_length(self.brush_sprites) - 1);
    Settings.terrain.tile_brush_x = Settings.terrain[$ "tile_brush_x"] ?? TERRAIN_DEF_TEX_BRUSH_X;
    Settings.terrain.tile_brush_y = Settings.terrain[$ "tile_brush_y"] ?? TERRAIN_DEF_TEX_BRUSH_Y;
    Settings.terrain.tile_brush_size = Settings.terrain[$ "tile_brush_size"] ?? TERRAIN_DEF_TEX_BRUSH_SIZE;
    // paint settings
    Settings.terrain.paint_brush_min = TERRAIN_DEF_PAINT_BRUSH_MIN;
    Settings.terrain.paint_brush_max = TERRAIN_DEF_PAINT_BRUSH_MAX;
    Settings.terrain.paint_strength_min = TERRAIN_DEF_PAINT_STRENGTH_MIN;
    Settings.terrain.paint_strength_max = TERRAIN_DEF_PAINT_STRENGTH_MAX;
    Settings.terrain.paint_brush_radius = Settings.terrain[$ "paint_brush_radius"] ?? TERRAIN_DEF_PAINT_BRUSH_RADIUS;
    Settings.terrain.paint_brush_index = clamp(Settings.terrain[$ "paint_brush_index"] ?? TERRAIN_DEF_PAINT_BRUSH_INDEX, 0, array_length(self.brush_sprites) - 1);
    Settings.terrain.paint_color = Settings.terrain[$ "paint_color"] ?? TERRAIN_DEF_PAINT_COLOR;
    Settings.terrain.paint_strength = Settings.terrain[$ "paint_strength"] ?? TERRAIN_DEF_PAINT_STREINGTH;
    #endregion
    
    self.texture_image = file_exists(FILE_TERRAIN_TEXTURE) ? sprite_add(FILE_TERRAIN_TEXTURE, 0, false, false, 0, 0) : sprite_add(PATH_GRAPHICS + DEFAULT_TILESET, 0, false, false, 0, 0);
    self.gradient_images = [
        spr_gradient,
        spr_gradient_4,
        spr_gradient_8
    ];
    
    // general settings
    self.height = DEFAULT_TERRAIN_HEIGHT;
    self.width = DEFAULT_TERRAIN_WIDTH;
    
    self.cursor_position = undefined;
    
    self.water = vertex_load("data/basic/water.vbuff", Stuff.graphics.format);
    self.depth_surface = surface_create(Settings.terrain.light_shadows_quality, Settings.terrain.light_shadows_quality);
    
    self.GenerateHeightData = function() {
        var data = buffer_create(4 * self.width * self.height, buffer_fixed, 1);
        buffer_poke(data, 0, buffer_u32, 0);
        buffer_poke(data, buffer_get_size(data) - 4, buffer_u32, 0);
        return data;
    };
    
    #macro TERRAIN_INTERNAL_CHUNK_SIZE 256
    #macro TERRAIN_INTERNAL_LOD_REDUCTION (8 * 8)
    
    self.height_data = self.GenerateHeightData();
    terrainops_set_active_data(buffer_get_address(self.height_data), self.width, self.height);
    self.terrain_buffer_data = terrainops_generate_internal(self.height_data, self.width, self.height);
    terrainops_set_active_vertex_data(buffer_get_address(self.terrain_buffer_data));
    self.terrain_buffers = [];
    self.terrain_lod_data = terrainops_generate_lod_internal(self.height_data, self.width, self.height);
    terrainops_set_lod_vertex_data(buffer_get_address(self.terrain_lod_data));
    self.terrain_lods = [];
    
    self.GetTerrainBufferIndex = function(x, y) {
        return x * ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE) + y;
    };
    
    self.GetTerrainBufferPosition = function(index) {
        return new Vector2(
            index div ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE),
            index mod ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE),
        );
    };
    
    self.GetTerrainBufferPositionWorld = function(index) {
        return new Vector2(
            (index div ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE)) * TERRAIN_INTERNAL_CHUNK_SIZE,
            (index mod ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE)) * TERRAIN_INTERNAL_CHUNK_SIZE
        );
    };
    
    self.RegenerateTerrainBuffer = function(x, y) {
    	var column_size = TERRAIN_INTERNAL_CHUNK_SIZE * self.height;
    	var local_chunk_width = min(TERRAIN_INTERNAL_CHUNK_SIZE, self.width - x * TERRAIN_INTERNAL_CHUNK_SIZE);
    	var local_chunk_height = min(TERRAIN_INTERNAL_CHUNK_SIZE, self.height - y * TERRAIN_INTERNAL_CHUNK_SIZE);
    	var column_address = x * column_size;
    	var chunk_address = column_address + y * TERRAIN_INTERNAL_CHUNK_SIZE /* dont use the local chunk height here */ * local_chunk_width;
    	var index = self.GetTerrainBufferIndex(x, y);
        if (self.terrain_buffers[index] != -1) {
            vertex_delete_buffer(self.terrain_buffers[index]);
            vertex_delete_buffer(self.terrain_lods[index]);
        }
        var chunk_offset = chunk_address * 3 * 6 * 4;
        var chunk_vertices = local_chunk_width * local_chunk_height * 6;
        self.terrain_buffers[index] = vertex_create_buffer_from_buffer_ext(self.terrain_buffer_data, self.vertex_format, chunk_offset, chunk_vertices);
        self.terrain_lods[index] = vertex_create_buffer_from_buffer_ext(self.terrain_lod_data, self.vertex_format, chunk_offset / TERRAIN_INTERNAL_LOD_REDUCTION, chunk_vertices / TERRAIN_INTERNAL_LOD_REDUCTION);
    
        vertex_freeze(self.terrain_buffers[index]);
        vertex_freeze(self.terrain_lods[index]);
    };
    
    self.RegenerateAllTerrainBuffers = function() {
        for (var i = 0, n = array_length(self.terrain_buffers); i < n; i++) {
            vertex_delete_buffer(self.terrain_buffers[i]);
            vertex_delete_buffer(self.terrain_lods[i]);
        }
        self.terrain_buffers = array_create(ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE) * ceil(self.width / TERRAIN_INTERNAL_CHUNK_SIZE), -1);
        self.terrain_lods = array_create(array_length(self.terrain_buffers), -1);
        for (var i = 0, n = array_length(self.terrain_buffers); i < n; i++) {
            var position = self.GetTerrainBufferPosition(i);
            self.RegenerateTerrainBuffer(position.x, position.y);
        }
    };
    
    self.RegenerateTerrainBufferRange = function(x1, y1, x2, y2) {
        x1 = floor(x1 / TERRAIN_INTERNAL_CHUNK_SIZE);
        x2 = ceil(x2 / TERRAIN_INTERNAL_CHUNK_SIZE);
        y1 = floor(y1 / TERRAIN_INTERNAL_CHUNK_SIZE);
        y2 = ceil(y2 / TERRAIN_INTERNAL_CHUNK_SIZE);
        for (var i = max(0, x1); i < min(x2, ceil(self.width / TERRAIN_INTERNAL_CHUNK_SIZE)); i++) {
            for (var j = max(0, y1); j < min(y2, ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE)); j++) {
                self.RegenerateTerrainBuffer(i, j);
            }
        }
    };
    
    self.RegenerateAllTerrainBuffers();
    
    self.color = (new Phoenix(self.width * Settings.terrain.color_scale, self.height * Settings.terrain.color_scale))
        .SetBrush(self.brush_sprites[Settings.terrain.paint_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE)
        .SetShader(shd_terrain_paint);
    self.texture = (new Phoenix(self.width, self.height, false, c_black))
        .SetBrush(self.brush_sprites[Settings.terrain.tile_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE)
        .SetShader(shd_terrain_paint_texture)
        .SetBlendEnable(false);
    
    self.GetTextureColorCode = function() {
        var tx = floor(0x100 * Settings.terrain.tile_brush_x / sprite_get_width(self.texture_image));
        var ty = floor(0x100 * Settings.terrain.tile_brush_y / sprite_get_height(self.texture_image));
        return tx | (ty << 8) | 0xff000000;
    };
    
    self.GetCurrentBrushTexture = function() {
        switch (Settings.terrain.mode) {
            case TerrainModes.Z: return sprite_get_texture(self.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
            case TerrainModes.TEXTURE: return sprite_get_texture(self.brush_sprites[Settings.terrain.tile_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
            case TerrainModes.COLOR: return sprite_get_texture(self.brush_sprites[Settings.terrain.paint_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH);
        }
        return spr_terrain_gen_part_circle;
    };
    
    self.GetCurrentBrushRadius = function() {
        switch (Settings.terrain.mode) {
            case TerrainModes.Z: return Settings.terrain.radius;
            case TerrainModes.TEXTURE: return Settings.terrain.tile_brush_radius / 2;
            case TerrainModes.COLOR: return Settings.terrain.paint_brush_radius / 2;
        }
        return 16;
    };
    
    self.GetGenerationAmplitude = function(scale) {
        var c = 10;
        var max_amplitude = c * power(max(self.width, self.height), 0.4);
        return max_amplitude * scale;
    };
    
    self.SaveTerrainStandalone = function(filename) {
        var carton = carton_create();
        var header_buffer = buffer_create(1024, buffer_grow, 1);
        buffer_write(header_buffer, buffer_string, json_stringify({
            width: self.width,
            height: self.height,
        }));
        carton_add(carton, "header", header_buffer, 0, buffer_tell(header_buffer));
        carton_add(carton, "height", self.height_data);
        carton_add(carton, "color", self.color.GetBuffer());
        carton_add(carton, "texture", self.texture.GetBuffer());
        
        carton_save(carton, filename, false);
        carton_destroy(carton);
    };
    
    self.LoadTerrainStandalone = function(filename) {
        var carton = carton_load(filename, false);
        // cartons go into the buffer in order but
        for(var i = 0, n = carton_count(carton); i < n; i++) {
            switch (carton_get_metadata(carton, i)) {
                case "header":
                    var data = carton_get_buffer(carton, i);
                    var json = json_parse(buffer_read(data, buffer_text));
                    self.width = json.width;
                    self.height = json.height;
                    buffer_delete(data);
                    break;
                case "height":
                    var data = carton_get_buffer(carton, i);
                    if (buffer_exists(self.height_data)) buffer_delete(self.height_data);
                    self.height_data = data;
                    terrainops_set_active_data(buffer_get_address(self.height_data), self.width, self.height);
                    if (buffer_exists(self.terrain_buffer_data)) buffer_delete(self.terrain_buffer_data);
                    self.terrain_buffer_data = terrainops_generate_internal(self.height_data, self.width, self.height);
                    terrainops_set_active_vertex_data(buffer_get_address(self.terrain_buffer_data));
                    self.terrain_lod_data = terrainops_generate_lod_internal(self.height_data, self.width, self.height);
                    terrainops_set_lod_vertex_data(buffer_get_address(self.terrain_lod_data));
                    self.RegenerateAllTerrainBuffers();
                    self.color.Reset(self.width * Settings.terrain.color_scale, self.height * Settings.terrain.color_scale);
                    self.texture.Reset(self.width, self.height);
                    break;
                case "color":
                    var data = carton_get_buffer(carton, i);
                    self.color.SetBuffer(data);
                    buffer_delete(data);
                    break;
                case "texture":
                    var data = carton_get_buffer(carton, i);
                    self.texture.SetBuffer(data);
                    buffer_delete(data);
                    break;
            }
        }
        carton_destroy(carton);
    };
    
    self.LoadAsset = function(directory) {
        directory += "/";
        try {
        } catch (e) {
            wtf("Could not load saved terrain data");
        }
    };
    
    self.SaveAsset = function(directory) {
        directory += "/";
    };
    
    self.LoadJSON = function(json) {
        self.width = json.width;
        self.height = json.height;
    };
    
    self.CreateJSON = function() {
        return {
            width: self.width,
            height: self.height,
        };
    };
    
    #region terrain actions
    self.Flatten = function(height = 0) {
        terrainops_flatten(self.height_data, self.terrain_buffer_data, height);
        self.RegenerateAllTerrainBuffers();
    };
    
    self.ApplyScale = function(scale = Settings.terrain.global_scale) {
        terrainops_apply_scale(self.height_data, self.terrain_buffer_data, scale);
        self.RegenerateAllTerrainBuffers();
    };
    
    self.Mutate = function(mutation_sprite_index, octaves, noise_strength, sprite_strength) {
        if (mutation_sprite_index < 0 || mutation_sprite_index >= array_length(self.gen_sprites)) {
            mutation_sprite_index = 0;
        }
        var ww = self.width;
        var hh = self.height;
        var sprite = self.gen_sprites[mutation_sprite_index].sprite;
        var nw = min(power(2, ceil(log2(ww))), 2048);
        var nh = min(power(2, ceil(log2(hh))), 2048);
        var macaw = macaw_generate_dll(nw, nh, octaves, noise_strength);
        var sprite_data = sprite_sample_get_buffer(sprite, TERRAIN_GEN_SPRITE_INDEX_MUTATE);
        terrainops_mutate(self.height_data, self.terrain_buffer_data, ww, hh, macaw.noise, nw, nh, noise_strength, sprite_data, sprite_get_width(sprite), sprite_get_height(sprite), sprite_strength);
        macaw.Destroy();
        self.RegenerateAllTerrainBuffers();
    };
    
    self.DrawWater = function() {
        if (!Settings.terrain.view_water) return;
        
        shader_set(shd_terrain_water);
        var water_level = 512 * power(Settings.terrain.water_level, 3);
        gpu_set_cullmode(cull_noculling);
        gpu_set_texfilter_ext(shader_get_sampler_index(shd_terrain_water, "displacementMap"), true);
        gpu_set_texrepeat_ext(shader_get_sampler_index(shd_terrain_water, "displacementMap"), true);
        gpu_set_texfilter(true);
        texture_set_stage(shader_get_sampler_index(shd_terrain_water, "displacementMap"), sprite_get_texture(spr_terrain_water_disp, 0));
        var mn = min(Settings.terrain.view_water_min_alpha, Settings.terrain.view_water_max_alpha);
        var mx = max(Settings.terrain.view_water_min_alpha, Settings.terrain.view_water_max_alpha);
        shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_WaterAlphaBounds"), mn, mx);
        shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_DisplacementScale"), 1.15);
        shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Time"), frac(current_time / 16000));
        shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Displacement"), 0.1);
        gpu_set_texfilter(false);
        matrix_set(matrix_world, matrix_build(0, 0, water_level, 0, 0, 0, 5, 5, 5));
        vertex_submit(self.water, pr_trianglelist, sprite_get_texture(spr_terrain_water, 0));
        shader_reset();
    };
    
    self.DrawDepth = function() {
        if (!Settings.terrain.light_shadows) return;
        
        var quality = Settings.terrain.light_shadows_quality;
        self.depth_surface = surface_rebuild(self.depth_surface, quality, quality);
        
        surface_set_target(self.depth_surface);
        draw_clear_alpha(c_black, 1);
        self.camera_light.SetProjectionOrtho();
        
        shader_set(shd_scene_depth);
        gpu_set_ztestenable(true);
        gpu_set_zwriteenable(true);
        gpu_set_cullmode(cull_noculling);
        gpu_set_blendenable(false);
        matrix_set(matrix_world, matrix_build_identity());
        
        for (var i = 0, n = array_length(self.terrain_buffers); i < n; i++) {
            vertex_submit(self.terrain_lods[i], pr_trianglelist, -1);
        }
        
        gpu_set_cullmode(cull_counterclockwise);
        gpu_set_blendenable(true);
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        shader_reset();
        surface_reset_target();
    };
    
    self.DrawTerrain = function() {
        self.DrawDepth();
        
        draw_set_color(c_white);
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
        gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
        
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
        var primary = Settings.terrain.light_direction.Rotate(new Vector3(0, 0, 1), Settings.terrain.light_primary_angle).Mul(-1);
        var secondary = Settings.terrain.light_direction.Rotate(new Vector3(0, 0, 1), Settings.terrain.light_secondary_angle).Mul(-1);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightAmbientColor"),
            ((Settings.terrain.light_ambient_colour >> 00) & 0xff) / 0xff,
            ((Settings.terrain.light_ambient_colour >> 08) & 0xff) / 0xff,
            ((Settings.terrain.light_ambient_colour >> 16) & 0xff) / 0xff
        );
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightDirection"), primary.x, primary.y, primary.z, Settings.terrain.light_primary_strength);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightDirectionSecondary"), secondary.x, secondary.y, secondary.z, Settings.terrain.light_secondary_strength);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_LightShadows"), Settings.terrain.light_shadows);
        
        shader_set_uniform_f_array(shader_get_uniform(shd_terrain, "u_LightVP"), self.camera_light.GetVPMatrix() ?? matrix_build_identity());
        gpu_set_tex_filter_ext(shader_get_sampler_index(shd_terrain, "s_DepthTexture"), true);
        texture_set_stage(shader_get_sampler_index(shd_terrain, "s_DepthTexture"), surface_get_texture(self.depth_surface));
        
        texture_set_stage(shader_get_sampler_index(shd_terrain, "s_ShadingGradient"), sprite_get_texture(self.gradient_images[Settings.terrain.gradient_image], 0));
        // fog uniforms
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStrength"), Settings.terrain.fog_enabled * !Settings.terrain.orthographic ? 1 : 0);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogStart"), Settings.terrain.fog_start);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogEnd"), Settings.terrain.fog_end);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_FogColor"),
            ((Settings.terrain.fog_color>> 00) & 0xff) / 0xff,
            ((Settings.terrain.fog_color>> 08) & 0xff) / 0xff,
            ((Settings.terrain.fog_color>> 16) & 0xff) / 0xff
        );
        // wireframe uniforms
        wireframe_enable(Settings.terrain.wireframe_alpha, );
        // water uniforms
        var water_level = 512 * power(Settings.terrain.water_level, 3);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterLevels"), water_level - 320, water_level, 0.75 * Settings.terrain.view_water);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_WaterColor"), 0.1, 0.1, 0.6);
        // terrain stuff
        matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "terrainSize"), self.width, self.height);
        // editor cursor stuff
        var xx = self.cursor_position ? self.cursor_position.x : 0;
        var yy = self.cursor_position ? self.cursor_position.y : 0;
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_Mouse"), xx, yy, self.GetCurrentBrushRadius(), self.cursor_position ? Settings.terrain.cursor_alpha : 0);
        texture_set_stage(shader_get_sampler_index(shd_terrain, "u_CursorTexture"), self.GetCurrentBrushTexture());
        // color stuff
        texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexColor"), surface_get_texture(self.color.surface));
        // texture stuff
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TextureTileSize"), sprite_get_width(self.texture_image) / (Settings.terrain.tile_brush_size - 1), sprite_get_height(self.texture_image) / (Settings.terrain.tile_brush_size - 1));
        // because gamemaker doesnt like sharing uniforms between vertex and fragment shader apparently
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainScale"), Settings.terrain.global_scale);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainSizeV"), self.width, self.height);
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_TerrainSizeF"), self.width, self.height);
        gpu_set_texfilter_ext(shader_get_sampler_index(shd_terrain, "u_TexLookup"), false);
        texture_set_stage(shader_get_sampler_index(shd_terrain, "u_TexLookup"), surface_get_texture(self.texture.surface));
        // other stuff
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "u_OptViewData"), Settings.terrain.view_data);
        
        var cutoff = Settings.terrain.view_distance;
        
        if (Settings.terrain.orthographic) {
            var vw = window_get_width();
            var vh = window_get_height();
            var use_lod_zero = self.camera.scale <= adjust_range(
                cutoff,
                Settings.terrain.view_distance_ortho_min,
                Settings.terrain.view_distance_ortho_max,
                Settings.terrain.view_distance_perspective_min,
                Settings.terrain.view_distance_perspective_max
            );
            
            var bounds_x1 = round((self.camera.x - vw * self.camera.scale / 2) / TERRAIN_INTERNAL_CHUNK_SIZE) - 1;
            var bounds_x2 = round((self.camera.x + vw * self.camera.scale / 2) / TERRAIN_INTERNAL_CHUNK_SIZE);
            var bounds_y1 = round((self.camera.y - vh * self.camera.scale / 2) / TERRAIN_INTERNAL_CHUNK_SIZE) - 1;
            var bounds_y2 = round((self.camera.y + vh * self.camera.scale / 2) / TERRAIN_INTERNAL_CHUNK_SIZE);
            
            for (var i = bounds_x1; i <= bounds_x2; i++) {
                for (var j = bounds_y1; j <= bounds_y2; j++) {
                    var index = self.GetTerrainBufferIndex(i, j);
                    if (!is_clamped(index, 0, array_length(self.terrain_buffers) - 1)) continue;
                    
                    if (use_lod_zero) {
                        vertex_submit(self.terrain_buffers[index], pr_trianglelist, sprite_get_texture(self.texture_image, 0));
                        self.stats.chunks.full++;
                        self.stats.triangles += vertex_get_number(self.terrain_buffers[index]);
                    } else {
                        vertex_submit(self.terrain_lods[index], pr_trianglelist, sprite_get_texture(self.texture_image, 0));
                        self.stats.chunks.lod++;
                        self.stats.triangles += vertex_get_number(self.terrain_lods[index]);
                    }
                }
            }
        } else {
            var chunk_angle = dcos(Settings.terrain.camera.fov * 1.5);
            for (var i = 0, n = array_length(self.terrain_buffers); i < n; i++) {
                var position = self.GetTerrainBufferPositionWorld(i);
                var chunk_distance = self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2);
                
                if (chunk_distance >= TERRAIN_INTERNAL_CHUNK_SIZE && self.camera.Dot(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2, 0) <= chunk_angle) continue;
                
                var use_lod_zero = chunk_distance <= cutoff;
                
                var neighbor_use_lod_zero =
                    (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
                    (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
                    (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 - TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff) ||
                    (self.camera.DistanceTo2D(position.x + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE, position.y + TERRAIN_INTERNAL_CHUNK_SIZE / 2 + TERRAIN_INTERNAL_CHUNK_SIZE) <= cutoff);
            
                if (neighbor_use_lod_zero || use_lod_zero) {
                    vertex_submit(self.terrain_buffers[i], pr_trianglelist, sprite_get_texture(self.texture_image, 0));
                    self.stats.chunks.full++;
                    self.stats.triangles += vertex_get_number(self.terrain_buffers[i]);
                }
                if (!use_lod_zero) {
                    vertex_submit(self.terrain_lods[i], pr_trianglelist, sprite_get_texture(self.texture_image, 0));
                    self.stats.chunks.lod++;
                    self.stats.triangles += vertex_get_number(self.terrain_lods[i]);
                }
            }
        }
        
        if (Settings.terrain.view_axes) {
            Stuff.graphics.DrawAxes();
        }
        
        self.DrawWater();
        
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        
        // overlay stuff
        self.camera.SetProjectionGUI();
        
        editor_gui_button(spr_camera_icons, 2, 16, window_get_height() - 48, 0, 0, null, function() {
            self.camera.Reset();
        });
    };
    #endregion
    
    #region Export methods
    self.AddToProject = function(name = "Terrain", density = 1, chunk_size = 0) {
        // ignore the export scale here; terrains attached to maps have their own scaling settings
        var results = terrainops_build_file("", TERRAINOPS_BUILD_INTERNAL, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, 1, self.texture_image, VertexFormatData.FULL, Settings.terrain.water_level);
        
        sprite_save(self.texture_image, 0, PATH_TEMP + "terrain_texture.png");
        var tex_base = tileset_create(PATH_TEMP + "terrain_texture.png");
        
        var mesh = new DataMesh(name);
        for (var i = 0, n = array_length(results); i < n; i++) {
            var value = results[i];
            var vbuff = vertex_create_buffer_from_buffer(value.buffer, Stuff.graphics.format);
            // there's a part of me that wants to just not include empty vertex
            // buffers, but i'd still prefer to save empty chunks so that the
            // user knows that something actually happened and the program
            // didnt fail randomly
            if (vertex_get_number(vbuff) > 0) vertex_freeze(vbuff);
            var submesh = mesh_create_submesh(mesh, value.buffer, vbuff, value.name);
            submesh.tex_base = tex_base;
            // do other materials later, perhaps
        }
        
        mesh.terrain_data = new MeshTerrainData(self.width, self.height, buffer_clone(self.height_data, buffer_fixed, 4));
        
        array_push(Game.mesh_terrain, mesh);
    };
    
    self.ExportD3D = function(filename, density = 1, chunk_size = 0) {
        terrainops_build_file(filename, TERRAINOPS_BUILD_D3D, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image, undefined, Settings.terrain.water_level);
    };
    
    self.ExportOBJ = function(filename, density = 1, chunk_size = 0) {
        terrainops_build_file(filename, TERRAINOPS_BUILD_OBJ, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image, undefined, Settings.terrain.water_level);
        terrainops_build_mtl(filename);
    };
    
    self.ExportVbuff = function(filename, density = 1, chunk_size = 0) {
        terrainops_build_file(filename, TERRAINOPS_BUILD_VBUFF, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image, Settings.terrain.output_vertex_format, Settings.terrain.water_level);
    };
    
    self.ExportHeightmap = function(filename) {
        var buffer = terrainops_to_heightmap(self.height_data);
        var surface = surface_create(self.width, self.height);
        buffer_set_surface(buffer, surface, 0);
        surface_save(surface, filename);
        buffer_delete(buffer);
        surface_free(surface);
    };
    
    self.ExportHeightmapData = function(filename) {
        buffer_save(self.height_data, filename);
    };
    #endregion
    
    self.ui = ui_init_terrain(self);
    
    self.camera = new Camera(0, 0, 64, 64, 64, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
        Stuff.terrain.mouse_interaction(mouse_vector);
    });
    self.camera.base_speed = 20;
    self.camera.Load(setting_get("terrain", "camera", undefined));
    self.camera.SetViewportAspect(function() {
        return Stuff.terrain.ui.SearchID("TERRAIN VIEWPORT").width;
    }, function() {
        return Stuff.terrain.ui.SearchID("TERRAIN VIEWPORT").height;
    });
    self.camera.SetCenter(self.ui.SearchID("TERRAIN VIEWPORT").width / 2, self.ui.SearchID("TERRAIN VIEWPORT").height / 2);
    self.camera.SetSkybox(Stuff.graphics.skybox_base, Stuff.graphics.default_skybox);
    
    self.camera_light = new Camera(500, -500, 564, 0, 0, 64, 0, 0, 1, 60, CAMERA_ZNEAR, 2500, null);
    self.camera_light.Load(setting_get("terrain", "camera_light", undefined));
    self.camera_light.Update = method(self.camera_light, function() {
        var main_camera = Stuff.terrain.camera;
        var dist = 500;
        self.x = main_camera.x - dist * Settings.terrain.light_direction.x;
        self.y = main_camera.y - dist * Settings.terrain.light_direction.y;
        self.z = main_camera.z - dist * Settings.terrain.light_direction.z;
        self.xto = self.x + Settings.terrain.light_direction.x;
        self.yto = self.y + Settings.terrain.light_direction.y;
        self.zto = self.z + Settings.terrain.light_direction.z;
    });
    self.camera_light.SetProjectionOrtho = method(self.camera_light, function() {
        self.view_mat = matrix_build_lookat(self.x, self.y, self.z, self.xto, self.yto, self.zto, self.xup, self.yup, self.zup);
        self.proj_mat = matrix_build_projection_ortho(Settings.terrain.light_shadows_quality / 2, -Settings.terrain.light_shadows_quality / 2, self.znear, self.zfar);
    
        camera_set_view_mat(self.camera, self.view_mat);
        camera_set_proj_mat(self.camera, self.proj_mat);
        camera_apply(self.camera);
    });
    
    Settings.terrain.camera = self.camera.Save();
    Settings.terrain.camera_light = self.camera_light.Save();
    
    wtf("Terrain initialization took " + debug_timer_finish());
    
    enum TerrainModes {
        Z,
        TEXTURE,
        COLOR,
    }
    
    enum TerrainSubmodes {
        MOUND,
        AVERAGE,
        ZERO,
        TEXTURE,
        COLOR,
    }
    
    self.mode_id = ModeIDs.TERRAIN;
}




