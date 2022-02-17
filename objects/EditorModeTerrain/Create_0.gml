#macro TERRAIN_GEN_SPRITE_INDEX_MUTATE                                          0
#macro TERRAIN_GEN_SPRITE_INDEX_BRUSH                                           1
#macro TERRAIN_GEN_SPRITE_INDEX_TEXTURE                                         2

event_inherited();

debug_timer_start();

Stuff.terrain = self;

vertex_format_begin();
vertex_format_add_position_3d();
self.vertex_format = vertex_format_end();

EditModeZ = function(position, dir) {
    var r = Settings.terrain.radius;
    terrainops_deform_settings(self.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH, position.x, position.y, r, dir * Settings.terrain.rate);
    
    switch (Settings.terrain.submode) {
        case TerrainSubmodes.MOUND: terrainops_deform_mold(); break;
        case TerrainSubmodes.AVERAGE: terrainops_deform_average(); break;
        case TerrainSubmodes.ZERO: terrainops_deform_zero(); break;
    }
    
    self.RegenerateTerrainBufferRange(position.x - r, position.y - r, position.x + r, position.y + r);
}

EditModeTexture = function(position) {
    var color_code = self.GetTextureColorCode();
    self.texture.Paint(position.x, position.y, Settings.terrain.tile_brush_radius, color_code, 1);
};

EditModeColor = function(position) {
    var csx = surface_get_width(self.color.surface) / self.width;
    var csy = surface_get_height(self.color.surface) / self.height;
    self.color.Paint(position.x * csx, position.y * csy, Settings.terrain.paint_brush_radius, Settings.terrain.paint_color, Settings.terrain.paint_strength);
};

self.mouse_interaction = function(mouse_vector) {
    self.cursor_position = undefined;
    
    if (mouse_vector[vec3.zz] < mouse_vector[5]) {
        var f = abs(mouse_vector[5] / mouse_vector[vec3.zz]);
        self.cursor_position = new vec2(mouse_vector[3] + mouse_vector[vec3.xx] * f, mouse_vector[4] + mouse_vector[vec3.yy] * f);
        
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

update = function() {
    self.texture.Validate();
    self.color.Validate();
    
    // you only get the keyboard shortcuts if we're running under the terrain config
    if (EDITOR_BASE_MODE == ModeIDs.TERRAIN) {
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
    
    if (Stuff.menu.active_element) return;
    
    if (mouse_within_view(view_3d)) {
        if (Settings.terrain.orthographic) {
            self.camera.UpdateOrtho();
        } else {
            self.camera.Update();
        }
        self.camera_light.Update();
    }
};

render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_3d: draw_clear(Settings.config.color_world); draw_editor_terrain(); break;
        case view_ribbon: draw_editor_menu(true); break;
        case view_hud: draw_editor_hud(); break;
    }
};

save = function() {
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
Settings.terrain.color_scale = Settings.terrain[$ "color_scale"] ?? 8;
// import and export settings
Settings.terrain.heightmap_scale = Settings.terrain[$ "heightmap_scale"] ?? 10;
Settings.terrain.save_scale = Settings.terrain[$ "save_scale"] ?? 1;
Settings.terrain.export_all = Settings.terrain[$ "export_all"] ?? false;
Settings.terrain.export_swap_uvs = Settings.terrain[$ "export_swap_uvs"] ?? false;
Settings.terrain.export_swap_zup = Settings.terrain[$ "export_swap_zup"] ?? false;
Settings.terrain.export_centered = Settings.terrain[$ "export_centered"] ?? false;
Settings.terrain.export_chunk_size = Settings.terrain[$ "export_chunk_size"] ?? 64;
Settings.terrain.export_smooth = Settings.terrain[$ "export_smooth"] ?? false;
Settings.terrain.export_smooth_threshold = Settings.terrain[$ "export_smooth_threshold"] ?? 60;
Settings.terrain.export_lod_levels = Settings.terrain[$ "export_lod_levels"] ?? 2;
Settings.terrain.output_vertex_format = Settings.terrain[$ "output_vertex_format"] ?? DEFAULT_VERTEX_FORMAT;
// viewer settings
Settings.terrain.view_water = Settings.terrain[$ "view_water"] ?? true;
Settings.terrain.view_water_min_alpha = Settings.terrain[$ "view_water_min_alpha"] ?? 0.5;
Settings.terrain.view_water_max_alpha = Settings.terrain[$ "view_water_max_alpha"] ?? 0.9;
Settings.terrain.water_level = Settings.terrain[$ "water_level"] ?? -0.2;
Settings.terrain.view_distance = Settings.terrain[$ "view_distance"] ?? 1200;
Settings.terrain.wireframe_alpha = Settings.terrain[$ "wireframe_alpha"] ?? 0.5;
Settings.terrain.cursor_alpha = Settings.terrain[$ "cursor_alpha"] ?? 0.5;
Settings.terrain.view_skybox = Settings.terrain[$ "view_skybox"] ?? true;
Settings.terrain.view_axes = Settings.terrain[$ "view_axes"] ?? true;
Settings.terrain.view_data = Settings.terrain[$ "view_data"] ?? TerrainViewData.DIFFUSE;
Settings.terrain.orthographic = Settings.terrain[$ "orthographic"] ?? false;
Settings.terrain.light_enabled = Settings.terrain[$ "light_enabled"] ?? true;
Settings.terrain.fog_enabled = Settings.terrain[$ "fog_enabled"] ?? true;
Settings.terrain.fog_color = Settings.terrain[$ "fog_color"] ?? c_white;
Settings.terrain.fog_start = Settings.terrain[$ "fog_start"] ?? 1000;
Settings.terrain.fog_end = Settings.terrain[$ "fog_end"] ?? 32000;
Settings.terrain.gradient_image = Settings.terrain[$ "gradient_image"] ?? 0;
// light settings
Settings.terrain.light_ambient = Settings.terrain[$ "light_ambient"] ?? { r: 0.25, g: 0.25, b: 0.25 };
Settings.terrain.light_direction = Settings.terrain[$ "light_direction"] ?? { x: -1, y: 1, z: -1 };
Settings.terrain.light_shadows = Settings.terrain[$ "light_shadows"] ?? false;
Settings.terrain.light_shadows_quality = Settings.terrain[$ "light_shadows_quality"] ?? 2048;
// height settings
Settings.terrain.brush_min = 1.5;
Settings.terrain.brush_max = 160;
Settings.terrain.rate_min = 0.05;
Settings.terrain.rate_max = 2.5;
Settings.terrain.rate = Settings.terrain[$ "rate"] ?? 0.5;
Settings.terrain.brush_index = clamp(Settings.terrain[$ "brush_index"] ?? 1, 0, array_length(self.brush_sprites) - 1);
Settings.terrain.radius = Settings.terrain[$ "radius"] ?? 4;
Settings.terrain.mode = TerrainModes.Z;
Settings.terrain.submode = TerrainSubmodes.MOUND;
Settings.terrain.global_scale = Settings.terrain[$ "global_scale"] ?? 1;
// texture settings
Settings.terrain.tile_brush_min = 1.5;
Settings.terrain.tile_brush_max = 250;
Settings.terrain.tile_brush_size_min = 4;
Settings.terrain.tile_brush_size_max = 256;
Settings.terrain.tile_brush_radius = Settings.terrain[$ "tile_brush_radius"] ?? 4;
Settings.terrain.tile_brush_index = clamp(Settings.terrain[$ "tile_brush_index"] ?? 1, 0, array_length(self.brush_sprites) - 1);
Settings.terrain.tile_brush_x = Settings.terrain[$ "tile_brush_x"] ?? 0;
Settings.terrain.tile_brush_y = Settings.terrain[$ "tile_brush_y"] ?? 0;
Settings.terrain.tile_brush_size = Settings.terrain[$ "tile_brush_size"] ?? 32;
// paint settings
Settings.terrain.paint_brush_min = 1.5;
Settings.terrain.paint_brush_max = 250;
Settings.terrain.paint_strength_min = 0.025;
Settings.terrain.paint_strength_max = 1;
Settings.terrain.paint_brush_radius = Settings.terrain[$ "paint_brush_radius"] ?? 4;
Settings.terrain.paint_brush_index = clamp(Settings.terrain[$ "paint_brush_index"] ?? 7, 0, array_length(self.brush_sprites) - 1);
Settings.terrain.paint_color = Settings.terrain[$ "paint_color"] ?? 0xffffffff;
Settings.terrain.paint_strength = Settings.terrain[$ "paint_strength"] ?? 0.05;
#endregion

self.camera = new Camera(0, 0, 64, 64, 64, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    Stuff.terrain.mouse_interaction(mouse_vector);
});
self.base_speed = 32;
self.camera.Load(setting_get("terrain", "camera", undefined));

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

texture_image = file_exists(FILE_TERRAIN_TEXTURE) ? sprite_add(FILE_TERRAIN_TEXTURE, 0, false, false, 0, 0) : sprite_add(PATH_GRAPHICS + DEFAULT_TILESET, 0, false, false, 0, 0);
gradient_images = [
    spr_gradient,
    spr_gradient_4,
    spr_gradient_8
];

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;

cursor_position = undefined;

water = vertex_load("data/basic/water.vbuff", Stuff.graphics.vertex_format);
depth_surface = surface_create(Settings.terrain.light_shadows_quality, Settings.terrain.light_shadows_quality);

GenerateHeightData = function() {
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

GetTerrainBufferIndex = function(x, y) {
    return x * ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE) + y;
};

GetTerrainBufferPosition = function(index) {
    return new vec2(
        index div ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE),
        index mod ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE),
    );
};

GetTerrainBufferPositionWorld = function(index) {
    return new vec2(
        (index div ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE)) * TERRAIN_INTERNAL_CHUNK_SIZE,
        (index mod ceil(self.height / TERRAIN_INTERNAL_CHUNK_SIZE)) * TERRAIN_INTERNAL_CHUNK_SIZE,
    );
};

RegenerateTerrainBuffer = function(x, y) {
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

RegenerateAllTerrainBuffers = function() {
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

RegenerateTerrainBufferRange = function(x1, y1, x2, y2) {
    x1 = floor(x1 / TERRAIN_INTERNAL_CHUNK_SIZE);
    x2 = ceil(x2 / TERRAIN_INTERNAL_CHUNK_SIZE);
    y1 = floor(y1 / TERRAIN_INTERNAL_CHUNK_SIZE);
    y2 = ceil(y2 / TERRAIN_INTERNAL_CHUNK_SIZE);
    for (var i = max(0, x1); i <= min(x2, (self.width div TERRAIN_INTERNAL_CHUNK_SIZE) - 1); i++) {
        for (var j = max(0, y1); j <= min(y2, (self.height div TERRAIN_INTERNAL_CHUNK_SIZE) - 1); j++) {
            self.RegenerateTerrainBuffer(i, j);
        }
    }
};

self.RegenerateAllTerrainBuffers();

color = (new Phoenix(self.width * Settings.terrain.color_scale, self.height * Settings.terrain.color_scale))
    .SetBrush(self.brush_sprites[Settings.terrain.paint_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE)
    .SetShader(shd_terrain_paint);
texture = (new Phoenix(self.width, self.height, c_black))
    .SetBrush(self.brush_sprites[Settings.terrain.tile_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE)
    .SetShader(shd_terrain_paint_texture)
    .SetBlendEnable(false);

GetTextureColorCode = function() {
    var tx = floor(0x100 * Settings.terrain.tile_brush_x / sprite_get_width(self.texture_image));
    var ty = floor(0x100 * Settings.terrain.tile_brush_y / sprite_get_height(self.texture_image));
    return tx | (ty << 8) | 0xff000000;
};

GetCurrentBrushTexture = function() {
    switch (Settings.terrain.mode) {
        case TerrainModes.Z: return sprite_get_texture(self.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
        case TerrainModes.TEXTURE: return sprite_get_texture(Stuff.terrain.brush_sprites[Settings.terrain.tile_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
        case TerrainModes.COLOR: return sprite_get_texture(Stuff.terrain.brush_sprites[Settings.terrain.paint_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH);
    }
    return spr_terrain_gen_part_circle;
};

GetCurrentBrushRadius = function() {
    switch (Settings.terrain.mode) {
        case TerrainModes.Z: return Settings.terrain.radius;
        case TerrainModes.TEXTURE: return Settings.terrain.tile_brush_radius / 2;
        case TerrainModes.COLOR: return Settings.terrain.paint_brush_radius / (self.color.width / self.width * 2);
    }
    return 16;
};

SaveTerrainStandalone = function(filename) {
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

LoadTerrainStandalone = function(filename) {
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

LoadAsset = function(directory) {
    directory += "/";
    try {
    } catch (e) {
        wtf("Could not load saved terrain data");
    }
};

SaveAsset = function(directory) {
    directory += "/";
};

LoadJSON = function(json) {
    self.width = json.width;
    self.height = json.height;
};

CreateJSON = function() {
    return {
        width: self.width,
        height: self.height,
    };
};

#region terrain actions
Flatten = function(height = 0) {
    terrainops_flatten(self.height_data, self.terrain_buffer_data, height);
    self.RegenerateAllTerrainBuffers();
};

ApplyScale = function(scale = Settings.terrain.global_scale) {
    terrainops_apply_scale(self.height_data, self.terrain_buffer_data, scale);
    self.RegenerateAllTerrainBuffers();
};

Mutate = function(mutation_sprite_index, octaves, noise_strength, sprite_strength) {
    if (mutation_sprite_index < 0 || mutation_sprite_index >= array_length(self.gen_sprites)) {
        mutation_sprite_index = 0;
    }
    var ww = self.width;
    var hh = self.height;
    var sprite = self.gen_sprites[mutation_sprite_index].sprite;
    var nw = min(power(2, ceil(log2(ww))), 2048);
    var nh = min(power(2, ceil(log2(hh))), 2048);
    var macaw = macaw_generate_dll(nw, nh, octaves, noise_strength).noise;
    var sprite_data = sprite_sample_get_buffer(sprite, TERRAIN_GEN_SPRITE_INDEX_MUTATE);
    terrainops_mutate(self.height_data, self.terrain_buffer_data, ww, hh, macaw, nw, nh, noise_strength, sprite_data, sprite_get_width(sprite), sprite_get_height(sprite), sprite_strength);
    buffer_delete(macaw);
    self.RegenerateAllTerrainBuffers();
};

DrawWater = function() {
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
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Time"), frac(current_time / 16000));
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Displacement"), 0.1);
    gpu_set_texfilter(false);
    matrix_set(matrix_world, matrix_build(self.x, self.y, water_level, 0, 0, 0, 5, 5, 5));
    vertex_submit(self.water, pr_trianglelist, sprite_get_texture(spr_terrain_water, 0));
    shader_reset();
};

DrawDepth = function() {
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
    
    for (var i = 0, n = array_length(Stuff.terrain.terrain_buffers); i < n; i++) {
        vertex_submit(Stuff.terrain.terrain_lods[i], pr_trianglelist, -1);
    }
    
    gpu_set_cullmode(cull_counterclockwise);
    gpu_set_blendenable(true);
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    shader_reset();
    surface_reset_target();
};

#endregion

#region Export methods
AddToProject = function(name = "Terrain", density = 1, swap_zup = false, swap_uv = false, chunk_size_x = self.width, chunk_size_y = self.height) {
    density = floor(density);
    
    /*
    // metadata setup
    var hcount = ceil(self.width / chunk_size_x);
    var vcount = ceil(self.height / chunk_size_y);
    
    var chunk_array = array_create(hcount * vcount);
    // vertex count, output address, x1, y1, x2, y2
    var chunk_meta = buffer_create(hcount * vcount * 6 * 8, buffer_fixed, 1);
    
    for (var i = 0, n = hcount * vcount; i < n; i++) {
        var xcell = i mod hcount;
        var ycell = i div hcount;
        var x1 = xcell * chunk_size_x;
        var y1 = ycell * chunk_size_y;
        var x2 = min((xcell + 1) * chunk_size_x, self.width);
        var y2 = min((ycell + 1) * chunk_size_y, self.height);
        
        chunk_array[i] = {
            position: { x: xcell, y: ycell },
            bounds: { x1: x1, y1: y1, x2: x2, y2: y2 },
            name: "Chunk" + string(xcell) + "_" + string(ycell),
            buffer: buffer_create(((x2 - x1) * (y2 - y1) + 1) * 6 * VERTEX_SIZE, buffer_fixed, 1),
        };
        
        buffer_poke(chunk_array[i].buffer, 0, buffer_u8, 0);
        buffer_poke(chunk_array[i].buffer, buffer_get_size(chunk_array[i].buffer) - 8, buffer_u8, 0);
        
        buffer_poke(chunk_meta, i * 6 * 8, buffer_u64, 0);
        buffer_poke(chunk_meta, i * 6 * 8 + 8, buffer_u64, int64(buffer_get_address(chunk_array[i].buffer)));
        buffer_poke(chunk_meta, i * 6 * 8 + 16, buffer_u64, x1);
        buffer_poke(chunk_meta, i * 6 * 8 + 24, buffer_u64, y1);
        buffer_poke(chunk_meta, i * 6 * 8 + 32, buffer_u64, x2);
        buffer_poke(chunk_meta, i * 6 * 8 + 40, buffer_u64, y2);
    }
    
    // build the output buffers
    var color_sprite = self.color.GetSprite();
    
    var sw = sprite_get_width(color_sprite) / Settings.terrain.color_scale;
    var sh = sprite_get_height(color_sprite) / Settings.terrain.color_scale;
    
    // at some point it'd be nice to properly sample from the color sprite again
    terrainops_build(
        chunk_meta, self.height_data, self.width, self.height,
        VERTEX_SIZE, Settings.terrain.export_all, Settings.terrain.export_swap_zup,
        Settings.terrain.export_swap_uvs, Settings.terrain.export_centered,
        density, Settings.terrain.save_scale
    );
    
    sprite_delete(color_sprite);
    
    // assemble the mesh data
    var mesh = new DataMesh(name);
    for (var i = 0, n = hcount * vcount; i < n; i++) {
        buffer_resize(chunk_array[i].buffer, buffer_peek(chunk_meta, i * 6 * 8, buffer_u64));
        var vbuff = vertex_create_buffer_from_buffer(chunk_array[i].buffer, Stuff.graphics.vertex_format);
        // there's a part of me that wants to just not include empty vertex
        // buffers, but i'd still prefer to save empty chunks so that the user
        // knows that something actually happened and the program didntn fail
        // randomly
        if (vertex_get_number(vbuff) > 0) vertex_freeze(vbuff);
        mesh_create_submesh(mesh, chunk_array[i].buffer, vbuff, undefined, chunk_array[i].name);
    }
    
    array_push(Game.meshes, mesh);
    
    return mesh;
    */
};

ExportD3D = function(filename, density = 1, chunk_size = 0) {
    terrainops_build_file(filename, TERRAINOPS_BUILD_D3D, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image);
};

ExportOBJ = function(filename, density = 1, chunk_size = 0) {
    terrainops_build_file(filename, TERRAINOPS_BUILD_OBJ, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image);
    terrainops_build_mtl(filename);
};

ExportVbuff = function(filename, density = 1, chunk_size = 0) {
    terrainops_build_file(filename, TERRAINOPS_BUILD_VBUFF, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, self.texture_image, Settings.terrain.output_vertex_format);
};

ExportHeightmap = function(filename, scale) {
    var buffer = terrainops_to_heightmap(self.height_data, scale);
    var surface = surface_create(self.width, self.height);
    buffer_set_surface(buffer, surface, 0);
    surface_save(surface, filename);
    buffer_delete(buffer);
    surface_free(surface);
};

ExportHeightmapData = function(filename) {
    buffer_save(self.height_data, filename);
};
#endregion

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

ui = ui_init_terrain(id);
mode_id = ModeIDs.TERRAIN;