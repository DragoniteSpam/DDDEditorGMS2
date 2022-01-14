event_inherited();

Stuff.terrain = self;

vertex_format_begin();
vertex_format_add_position_3d();
self.vertex_format = vertex_format_end();

self.camera = new Camera(0, 0, 256, 256, 256, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    Stuff.terrain.mouse_interaction(mouse_vector);
});
self.camera.Load(setting_get("terrain", "camera", undefined));

EditModeZ = function(position, dir) {
    var t = 0;
    var coeff = self.radius * self.style_radius_coefficient[self.style];
    var list_range = ds_list_create();
    
    for (var i = max(0, position.x - self.radius + 1); i < min(self.width, position.x + self.radius + 1); i++) {
        for (var j = max(0, position.y - self.radius + 1); j < min(self.height, position.y + self.radius + 1); j++) {
            var d1 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 0.5);
            var d2 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 0.5);
            var d3 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 1.5);
            var d4 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 1.5);
            if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
                t = t + terrain_get_z(self, floor(i), floor(j));
                ds_list_add(list_range, [floor(i), floor(j), mean(d1, d2, d3, d4)]);
            }
        }
    }
    
    var avg = t / ds_list_size(list_range);
    
    for (var i = 0; i < ds_list_size(list_range); i++) {
        var coordinates = list_range[| i];
        self.submode_equation[self.submode](coordinates[vec3.xx], coordinates[vec3.yy], dir, avg, coordinates[vec3.zz]);
    }
    
    if (!ds_list_empty(list_range)) {
        terrain_refresh_vertex_buffer(self);
    }
    
    ds_list_destroy(list_range);
}

EditModeTexture = function(position) {
    var color_code = self.GetTextureColorCode();
    self.texture.Paint(position.x, position.y, self.radius, color_code & 0x00ffffff, (color_code >> 24) / 0xff);
}

EditModeColor = function(position) {
    self.color.Paint(position.x * self.color_scale, position.y * self.color_scale, self.radius * self.color_scale, self.paint_color, self.paint_strength);
}

self.mouse_interaction = function(mouse_vector) {
    self.cursor_position = undefined;
    
    if (mouse_vector[vec3.zz] < mouse_vector[5]) {
        var f = abs(mouse_vector[5] / mouse_vector[vec3.zz]);
        self.cursor_position = new vec2((mouse_vector[3] + mouse_vector[vec3.xx] * f) / Settings.terrain.view_scale, (mouse_vector[4] + mouse_vector[vec3.yy] * f) / Settings.terrain.view_scale);
        
        if (Controller.mouse_left) {
            switch (self.mode) {
                case TerrainModes.Z: self.EditModeZ(self.cursor_position, 1); break;
                case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
            }
        }
        
        if (Controller.mouse_right) {
            switch (self.mode) {
                case TerrainModes.Z: self.EditModeZ(self.cursor_position, -1); break;
                case TerrainModes.TEXTURE: self.EditModeTexture(self.cursor_position); break;
                case TerrainModes.COLOR: self.EditModeColor(self.cursor_position); break;
            }
        }
        
        if (Controller.release_right) {
            switch (self.mode) {
                case TerrainModes.Z: break;
                case TerrainModes.TEXTURE: break;
                case TerrainModes.COLOR: self.color.Finish(); break;
            }
        }
        
        if (Controller.release_left) {
            switch (self.mode) {
                case TerrainModes.Z: break;
                case TerrainModes.TEXTURE: break;
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
    // viewer settings
    Settings.terrain.camera = self.camera.Save();
    // editing settings
    // height defaults
    Settings.terrain.rate = self.rate;
    Settings.terrain.radius = self.radius;
    Settings.terrain.mode = self.mode;
    Settings.terrain.submode = self.submode;
    Settings.terrain.style = self.style;
    Settings.terrain.tile_brush_x = self.tile_brush_x;
    Settings.terrain.tile_brush_y = self.tile_brush_y;
    Settings.terrain.paint_color = self.paint_color;
    Settings.terrain.paint_strength = self.paint_strength;
};

texture_name = DEFAULT_TILESET;
texture_image = sprite_add(PATH_GRAPHICS + texture_name, 0, false, false, 0, 0);

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;
color_scale = 8;

Settings.terrain.save_scale = Settings.terrain[$ "save_scale"] ?? 1;
Settings.terrain.export_all = Settings.terrain[$ "export_all"] ?? false;
Settings.terrain.view_water = Settings.terrain[$ "view_water"] ?? true;
Settings.terrain.view_water_min_alpha = Settings.terrain[$ "view_water_min_alpha"] ?? 0.5;
Settings.terrain.view_water_max_alpha = Settings.terrain[$ "view_water_max_alpha"] ?? 0.9;
Settings.terrain.water_level = Settings.terrain[$ "water_level"] ?? -0.2;
Settings.terrain.view_grid = Settings.terrain[$ "view_grid"] ?? true;
Settings.terrain.view_cursor = Settings.terrain[$ "view_cursor"] ?? true;
Settings.terrain.view_axes = Settings.terrain[$ "view_axes"] ?? true;
Settings.terrain.view_normals = Settings.terrain[$ "view_normals"] ?? false;
Settings.terrain.heightmap_scale = Settings.terrain[$ "heightmap_scale"] ?? 10;
Settings.terrain.export_swap_uvs = Settings.terrain[$ "export_swap_uvs"] ?? false;
Settings.terrain.export_swap_zup = Settings.terrain[$ "export_swap_zup"] ?? false;
Settings.terrain.export_centered = Settings.terrain[$ "export_centered"] ?? false;
Settings.terrain.export_chunk_size = Settings.terrain[$ "export_chunk_size"] ?? 64;
Settings.terrain.export_smooth = Settings.terrain[$ "export_smooth"] ?? false;
Settings.terrain.export_smooth_threshold = Settings.terrain[$ "export_smooth_threshold"] ?? 60;
Settings.terrain.orthographic = Settings.terrain[$ "orthographic"] ?? false;
Settings.terrain.output_vertex_format = Settings.terrain[$ "output_vertex_format"] ?? DEFAULT_VERTEX_FORMAT;

Settings.terrain.view_scale = Settings.terrain[$ "view_scale"] ?? 4;
Settings.terrain.light_enabled = Settings.terrain[$ "light_enabled"] ?? true;
Settings.terrain.light_ambient = Settings.terrain[$ "light_ambient"] ?? c_black;

Settings.terrain.fog_enabled = Settings.terrain[$ "fog_enabled"] ?? true;
Settings.terrain.fog_color = Settings.terrain[$ "fog_color"] ?? c_white;
Settings.terrain.fog_start = Settings.terrain[$ "fog_start"] ?? 1000;
Settings.terrain.fog_end = Settings.terrain[$ "fog_end"] ?? 32000;

cursor_position = undefined;
// height defaults
brush_min = 1.5;
brush_max = 20;
rate_min = 0.02;
rate_max = 1;
// height settings
rate = setting_get("terrain", "rate", 0.125);
radius = setting_get("terrain", "radius", 4);
mode = setting_get("terrain", "mode", TerrainModes.Z);
submode = setting_get("terrain", "submode", TerrainSubmodes.MOUND);
style = setting_get("terrain", "style", TerrainStyles.CIRCLE);
// texture settings
tile_brush_x = setting_get("terrain", "tile_brush_x", 0);
tile_brush_y = setting_get("terrain", "tile_brush_y", 0);
tile_brush_w = setting_get("terrain", "tile_brush_w", 16);
tile_brush_h = setting_get("terrain", "tile_brush_h", 16);
// paint defaults
paint_strength_min = 0.01;
paint_strength_max = 1;
// paint settings
paint_color = setting_get("terrain", "paint_color", 0xffffffff);
paint_strength = setting_get("terrain", "paint_strength", 0.05);

// remember to add these to the list in dialog_terrain_mutate()
mutation_sprites = [
    spr_terrain_gen_flat,
    spr_terrain_gen_bullseye,
    spr_terrain_gen_mountain,
    spr_terrain_gen_craters,
    spr_terrain_gen_drago,
    spr_terrain_gen_juju,
];

water = vertex_load("data/basic/water.vbuff", Stuff.graphics.vertex_format);

var t = get_timer();

GenerateHeightData = function() {
    var data = buffer_create(4 * width * height, buffer_fixed, 1);
    buffer_poke(data, 0, buffer_u32, 0);
    buffer_poke(data, buffer_get_size(data) - 4, buffer_u32, 0);
    return data;
};

self.height_data = self.GenerateHeightData();

self.terrain_buffer_data = terrainops_generate(self.height_data, self.width, self.height);
self.terrain_buffer = vertex_create_buffer_from_buffer(self.terrain_buffer_data, self.vertex_format);
vertex_freeze(self.terrain_buffer);

color = new Phoenix(Stuff.terrain.width * Stuff.terrain.color_scale, Stuff.terrain.height * Stuff.terrain.color_scale);
color.SetBrush(spr_terrain_default_brushes, 7);
color.SetShader(shd_terrain_paint);
texture = new Phoenix(Stuff.terrain.width, Stuff.terrain.height, c_black);
texture.SetBrush(spr_terrain_default_brushes, 7);
texture.SetBlendEnable(false);

GetTextureColorCode = function() {
    var tx = min(self.tile_brush_x, self.tile_brush_x + self.tile_brush_w);
    var ty = min(self.tile_brush_y, self.tile_brush_y + self.tile_brush_h);
    tx = floor(255 * tx / sprite_get_width(self.texture_image));
    ty = floor(255 * ty / sprite_get_height(self.texture_image));
    /// @todo let's figure out what we're going to do with the second triangle
    // texture eventually
    return tx | (ty << 8) | (tx << 16) | (ty << 24);
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
Flatten = function() {
    buffer_fill(self.height_data, 0, buffer_f32, 0, buffer_get_size(self.height_data));
    for (var i = 8, n = buffer_get_size(self.terrain_buffer_data); i < n; i += VERTEX_SIZE_TERRAIN) {
        buffer_poke(self.terrain_buffer_data, i, buffer_f32, 0);
    }
    terrain_refresh_vertex_buffer(self);
};

Mutate = function(mutation_sprite_index, octaves, noise_strength, texture_strength) {
    if (mutation_sprite_index < 0 || mutation_sprite_index >= array_length(self.mutation_sprites)) {
        mutation_sprite_index = 0;
    }
    var ww = self.width;
    var hh = self.height;
    var sprite = self.mutation_sprites[mutation_sprite_index];
    var data = macaw_generate_dll(ww, hh, octaves, noise_strength).noise;
    for (var i = 0; i < (ww - 1) * (hh - 1); i++) {
        var sample = sprite_sample(sprite, 0, (i % ww) / ww, (i div ww) / hh);
        var sample_r = (( sample        & 0xff) / 0x7f - 1) * texture_strength;
        var sample_g = (((sample >>  8) & 0xff) / 0x7f - 1) * texture_strength;
        var sample_b = (((sample >> 16) & 0xff) / 0x7f - 1) * texture_strength;
        var sample_a = (((sample >> 24) & 0xff) / 0x7f - 1) * texture_strength;
        var noise = buffer_peek(data, i * 4, buffer_f32) - noise_strength / 2;
        terrain_add_z(self, i mod ww, i div ww, noise + sample_r);
    }
    buffer_delete(data);
    terrain_refresh_vertex_buffer(self);
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
AddToProject = function(name = "Terrain", density = 1, swap_zup = false, swap_uv = false, chunk_size = 0) {
    var chunks = self.BuildBufferChunks(density, chunk_size);
    var mesh = new DataMesh(name);
    for (var i = 0, n = array_length(chunks); i < n; i++) {
        var vbuff = vertex_create_buffer_from_buffer(chunks[i].buffer, Stuff.graphics.vertex_format);
        vertex_freeze(vbuff);
        mesh_create_submesh(mesh, chunks[i].buffer, vbuff, undefined, chunks[i].name);
    }
    array_push(Game.meshes, mesh);
    return mesh;
};

/// @return an array of { buffer, name }
BuildBufferChunks = function(density = 1, chunk_size = 0) {
    var collection = [];
    
    var main_buffer = self.BuildBuffer(density);
    
    if (chunk_size > 0) {
        var chunks = vertex_buffer_as_chunks(main_buffer, chunk_size, max(1, ceil(self.width / chunk_size)), max(1, ceil(self.height / chunk_size)));
        buffer_delete(main_buffer);
        var keys = variable_struct_get_names(chunks);
        for (var i = 0, n = array_length(keys); i < n; i++) {
            var chunk = chunks[$ keys[i]];
            array_push(collection, { buffer: chunk.buffer, name: string(chunk.coords.x) + "_" + string(chunk.coords.y) });
        }
    } else {
        array_push(collection, { buffer: main_buffer, name: "" });
    }
    
    return collection;
};

BuildBuffer = function(density = 1) {
    density = floor(density);
    
    var color_sprite = self.color.GetSprite();
    
    var sw = sprite_get_width(color_sprite) / self.color_scale;
    var sh = sprite_get_height(color_sprite) / self.color_scale;
    
    // at some point it'd be nice to properly sample from the color sprite again
    var output = terrainops_build(
        Settings.terrain.height_data, Settings.terrain.width, Settings.terrain.height,
        VERTEX_SIZE, Settings.terrain.export_all, Settings.terrain.export_swap_zup,
        Settings.terrain.export_swap_uvs, Settings.terrain.export_centered,
        density, Settings.terrain.save_scale
    );
    
    sprite_sample_remove_from_cache(color_sprite, 0);
    sprite_delete(color_sprite);
    
    if (Settings.terrain.export_smooth) {
        meshops_set_normals_smooth(buffer_get_address(output), buffer_get_size(output), dcos(Settings.terrain.export_smooth_threshold));
    } else {
        meshops_set_normals_flat(buffer_get_address(output), buffer_get_size(output));
    }
    
    return output;
};

ExportD3D = function(filename, density = 1, chunk_size = 0) {
    var mesh = self.AddToProject("Terrain", density, false, false, chunk_size);
    export_d3d(filename, mesh);
    mesh.Destroy();
};

ExportOBJ = function(filename, density = 1, chunk_size = 0) {
    var mesh = self.AddToProject("Terrain", density, Settings.terrain.export_swap_zup, Settings.terrain.export_swap_uvs, chunk_size);
    export_obj(filename, mesh, "DDD Terrain");
    mesh.Destroy();
}

ExportVbuff = function(filename, density = 1, chunk_size = 0) {
    var mesh = self.AddToProject("Terrain", density, false, false, chunk_size);
    export_vb(filename, mesh, Settings.terrain.output_vertex_format);
    mesh.Destroy();
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

wtf("Terrain creation took " + string((get_timer() - t) / 1000) + " milliseconds");

enum TerrainModes {
    Z,
    TEXTURE,
    COLOR,
}

enum TerrainSubmodes {
    MOUND,
    AVERAGE,
    AVG_FLAT,
    ZERO,
    TEXTURE,
    COLOR,
}

enum TerrainStyles {
    BLOCK,
    CIRCLE,
}

submode_equation = [
    function(x, y, dir, avg, dist) {
        terrain_add_z(self, x, y, dir * self.rate * dcos(max(1, dist)));
    },
    function(x, y, dir, avg, dist) {
        terrain_set_z(self, x, y, lerp(terrain_get_z(self, x, y), avg, self.rate / 20));
    },
    function(x, y, dir, avg, dist) {
        terrain_set_z(self, x, y, avg);
    },
    function(x, y, dir, avg, dist) {
        terrain_set_z(self, x, y, 0);
    }
];

style_radius_coefficient = [2, 1];

ui = ui_init_terrain(id);
mode_id = ModeIDs.TERRAIN;