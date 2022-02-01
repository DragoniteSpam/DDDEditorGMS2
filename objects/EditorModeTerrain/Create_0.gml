#macro TERRAIN_GEN_SPRITE_INDEX_MUTATE                                          0
#macro TERRAIN_GEN_SPRITE_INDEX_BRUSH                                           1
#macro TERRAIN_GEN_SPRITE_INDEX_TEXTURE                                         2

event_inherited();

debug_timer_start();

Stuff.terrain = self;

vertex_format_begin();
vertex_format_add_position_3d();
self.vertex_format = vertex_format_end();

self.camera = new Camera(0, 0, 256, 256, 256, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    Stuff.terrain.mouse_interaction(mouse_vector);
});
self.camera.Load(setting_get("terrain", "camera", undefined));

EditModeZ = function(position, dir) {
    terrainops_deform_settings(self.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH, position.x, position.y, Settings.terrain.radius, dir * Settings.terrain.rate);
    
    switch (Settings.terrain.submode) {
        case TerrainSubmodes.MOUND: terrainops_deform_mold(); break;
        case TerrainSubmodes.AVERAGE: terrainops_deform_average(); break;
        case TerrainSubmodes.ZERO: terrainops_deform_zero(); break;
    }
    
    self.Refresh();
}

EditModeTexture = function(position) {
    var color_code = self.GetTextureColorCode();
    self.texture.Paint(position.x, position.y, Settings.terrain.tile_brush_radius, color_code, 1);
};

EditModeColor = function(position) {
    var cs = Settings.terrain.color_scale;
    self.color.Paint(position.x * cs, position.y * cs, Settings.terrain.paint_brush_radius * cs, Settings.terrain.paint_color, Settings.terrain.paint_strength);
};

self.mouse_interaction = function(mouse_vector) {
    self.cursor_position = undefined;
    
    if (mouse_vector[vec3.zz] < mouse_vector[5]) {
        var f = abs(mouse_vector[5] / mouse_vector[vec3.zz]);
        self.cursor_position = new vec2((mouse_vector[3] + mouse_vector[vec3.xx] * f) / Settings.terrain.view_scale, (mouse_vector[4] + mouse_vector[vec3.yy] * f) / Settings.terrain.view_scale);
        
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
    
    if (Stuff.menu.active_element) {
        return false;
    }
    
    if (mouse_within_view(view_3d)) {
        if (Settings.terrain.orthographic) {
            self.camera.UpdateOrtho();
        } else {
            self.camera.Update();
        }
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
    // all of the other things now go directly to the terrain settings object
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
Settings.terrain.output_vertex_format = Settings.terrain[$ "output_vertex_format"] ?? DEFAULT_VERTEX_FORMAT;
// viewer settings
Settings.terrain.view_water = Settings.terrain[$ "view_water"] ?? true;
Settings.terrain.view_water_min_alpha = Settings.terrain[$ "view_water_min_alpha"] ?? 0.5;
Settings.terrain.view_water_max_alpha = Settings.terrain[$ "view_water_max_alpha"] ?? 0.9;
Settings.terrain.water_level = Settings.terrain[$ "water_level"] ?? -0.2;
Settings.terrain.view_wireframe = Settings.terrain[$ "view_wireframe"] ?? true;
Settings.terrain.wireframe_alpha = Settings.terrain[$ "wireframe_alpha"] ?? 0.5;
Settings.terrain.view_skybox = Settings.terrain[$ "view_skybox"] ?? true;
Settings.terrain.view_cursor = Settings.terrain[$ "view_cursor"] ?? true;
Settings.terrain.view_axes = Settings.terrain[$ "view_axes"] ?? true;
Settings.terrain.view_data = Settings.terrain[$ "view_data"] ?? TerrainViewData.DIFFUSE;
Settings.terrain.orthographic = Settings.terrain[$ "orthographic"] ?? false;
Settings.terrain.view_scale = Settings.terrain[$ "view_scale"] ?? 4;
Settings.terrain.light_enabled = Settings.terrain[$ "light_enabled"] ?? true;
Settings.terrain.light_ambient = Settings.terrain[$ "light_ambient"] ?? c_black;
Settings.terrain.fog_enabled = Settings.terrain[$ "fog_enabled"] ?? true;
Settings.terrain.fog_color = Settings.terrain[$ "fog_color"] ?? c_white;
Settings.terrain.fog_start = Settings.terrain[$ "fog_start"] ?? 1000;
Settings.terrain.fog_end = Settings.terrain[$ "fog_end"] ?? 32000;
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
Settings.terrain.tile_brush_size = Settings.terrain[$ "tile_brush_size"] ?? 16;
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

texture_name = DEFAULT_TILESET;
texture_image = sprite_add(PATH_GRAPHICS + texture_name, 0, false, false, 0, 0);

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;

cursor_position = undefined;

water = vertex_load("data/basic/water.vbuff", Stuff.graphics.vertex_format);

GenerateHeightData = function() {
    var data = buffer_create(4 * self.width * self.height, buffer_fixed, 1);
    buffer_poke(data, 0, buffer_u32, 0);
    buffer_poke(data, buffer_get_size(data) - 4, buffer_u32, 0);
    return data;
};

Refresh = function() {
    vertex_delete_buffer(self.terrain_buffer);
    self.terrain_buffer = vertex_create_buffer_from_buffer(self.terrain_buffer_data, self.vertex_format);
    vertex_freeze(self.terrain_buffer);
};

self.height_data = self.GenerateHeightData();
terrainops_set_active_data(buffer_get_address(self.height_data), self.width, self.height);
self.terrain_buffer_data = terrainops_generate_internal(self.height_data, self.width, self.height);
terrainops_set_active_vertex_data(buffer_get_address(self.terrain_buffer_data));
self.terrain_buffer = vertex_create_buffer_from_buffer(self.terrain_buffer_data, self.vertex_format);
vertex_freeze(self.terrain_buffer);

color = new Phoenix(self.width * Settings.terrain.color_scale, self.height * Settings.terrain.color_scale);
color.SetBrush(self.brush_sprites[Settings.terrain.paint_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
color.SetShader(shd_terrain_paint);
texture = new Phoenix(self.width, self.height, c_black);
texture.SetBrush(self.brush_sprites[Settings.terrain.tile_brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
texture.SetShader(shd_terrain_paint_texture);

GetTextureColorCode = function() {
    var tx = floor(256 * Settings.terrain.tile_brush_x / sprite_get_width(self.texture_image));
    var ty = floor(256 * Settings.terrain.tile_brush_y / sprite_get_height(self.texture_image));
    return tx | (ty << 8) | 0xff000000;
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
    self.Refresh();
};

ApplyScale = function(scale = Settings.terrain.global_scale) {
    terrainops_apply_scale(self.height_data, self.terrain_buffer_data, scale);
    self.Refresh();
};

Mutate = function(mutation_sprite_index, octaves, noise_strength, sprite_strength) {
    if (mutation_sprite_index < 0 || mutation_sprite_index >= array_length(self.gen_sprites)) {
        mutation_sprite_index = 0;
    }
    var ww = self.width;
    var hh = self.height;
    var sprite = self.gen_sprites[mutation_sprite_index].sprite;
    var macaw = macaw_generate_dll(ww, hh, octaves, noise_strength).noise;
    var sprite_data = sprite_sample_get_buffer(sprite, TERRAIN_GEN_SPRITE_INDEX_MUTATE);
    terrainops_mutate(self.height_data, self.terrain_buffer_data, ww, hh, macaw, ww, hh, noise_strength, sprite_data, sprite_get_width(sprite), sprite_get_height(sprite), sprite_strength);
    buffer_delete(macaw);
    self.Refresh();
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
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Time"), frac(current_time / 20000));
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Displacement"), 0.0625);
    gpu_set_texfilter(false);
    matrix_set(matrix_world, matrix_build(self.x, self.y, water_level, 0, 0, 0, 5, 5, 5));
    vertex_submit(self.water, pr_trianglelist, sprite_get_texture(spr_terrain_water, 0));
    shader_reset();
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
    terrainops_build_file(filename, TERRAINOPS_BUILD_D3D, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale);
};

ExportOBJ = function(filename, density = 1, chunk_size = 0) {
    terrainops_build_file(filename, TERRAINOPS_BUILD_OBJ, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale);
};

ExportVbuff = function(filename, density = 1, chunk_size = 0) {
    terrainops_build_file(filename, TERRAINOPS_BUILD_VBUFF, chunk_size, Settings.terrain.export_all, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, Settings.terrain.export_centered, density, Settings.terrain.save_scale, Settings.terrain.output_vertex_format);
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