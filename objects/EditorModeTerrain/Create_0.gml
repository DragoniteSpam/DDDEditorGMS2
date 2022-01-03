event_inherited();

Stuff.terrain = self;

vertex_format_begin();
vertex_format_add_position_3d();
self.vertex_format = vertex_format_end();

def_x = -1024;
def_y = -1024;
def_z = 1024;
def_xto = 1024;
def_yto = 1024;
def_zto = 0;
def_xup = 0;
def_yup = 0;
def_zup = 1;
def_fov = 60;

x = setting_get("terrain", "x", def_x);
y = setting_get("terrain", "y", def_y);
z = setting_get("terrain", "z", def_z);

xto = setting_get("terrain", "xto", def_xto);
yto = setting_get("terrain", "yto", def_yto);
zto = setting_get("terrain", "zto", def_zto);

xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("terrain", "fov", def_fov);
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_terrain;
render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_3d: draw_clear(Settings.config.color_world); draw_editor_terrain(); break;
        case view_ribbon: draw_editor_terrain_menu(); break;
        case view_hud: draw_editor_hud(); break;
    }
};
save = function() {
    Settings.terrain.x = x;
    Settings.terrain.y = y;
    Settings.terrain.z = z;
    Settings.terrain.xto = xto;
    Settings.terrain.yto = yto;
    Settings.terrain.zto = zto;
    Settings.terrain.fov = fov;
    Settings.terrain.save_scale = self.save_scale;
    Settings.terrain.export_all = self.export_all;
    Settings.terrain.view_water = self.view_water;
    Settings.terrain.water_level = self.water_level;
    Settings.terrain.view_grid = self.view_grid;
    Settings.terrain.heightmap_scale = self.heightmap_scale;
    Settings.terrain.export_swap_uvs = self.export_swap_uvs;
    Settings.terrain.export_swap_zup = self.export_swap_zup;
    Settings.terrain.export_centered = self.export_centered;
    Settings.terrain.export_chunk_size = self.export_chunk_size;
    Settings.terrain.output_vertex_format = self.output_vertex_format;
};

texture_name = DEFAULT_TILESET;
texture = sprite_add(PATH_GRAPHICS + texture_name, 0, false, false, 0, 0);

vertices_per_square = 6;

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;
color_scale = 8;

view_scale = 32;
save_scale = setting_get("terrain", "save_scale", 1);
export_all = setting_get("terrain", "export_all", false);
view_water = setting_get("terrain", "view_water", true);
water_level = setting_get("terrain", "water_level", -0.2);
view_grid = setting_get("terrain", "view_grid", true);
heightmap_scale = setting_get("terrain", "heightmap_scale", 10);
export_swap_uvs = setting_get("terrain", "export_swap_uvs", false);
export_swap_zup = setting_get("terrain", "export_swap_zup", false);
export_centered = setting_get("terrain", "export_centered", false);
export_chunk_size = setting_get("terrain", "export_chunk_size", 64);
smooth_shading = false;
dual_layer = false;
orthographic = false;
orthographic_scale = 1;
output_vertex_format = setting_get("terrain", "output_vertex_format", DEFAULT_VERTEX_FORMAT);

cursor_position = undefined;
// height defaults
brush_min = 1.5;
brush_max = 20;
rate_min = 0.02;
rate_max = 1;
// height settings
rate = 0.125;
radius = 4;
mode = TerrainModes.Z;
submode = TerrainSubmodes.MOUND;
style = TerrainStyles.CIRCLE;
// texture settings
tile_brush_x = terrain_tile_size;
tile_brush_y = terrain_tile_size;
// paint defaults
paint_strength_min = 0.01;
paint_strength_max = 1;
// paint settings
paint_color = 0xffffffff;
paint_strength = 0.05;

mutation_sprites = [
    spr_terrain_gen_flat,
    spr_terrain_gen_bullseye,
];

water = vertex_load("data/basic/water.vbuff", Stuff.graphics.vertex_format);

var t = get_timer();

height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
color = new (function() constructor {
    self.surface = surface_create(Stuff.terrain.width * Stuff.terrain.color_scale, Stuff.terrain.height * Stuff.terrain.color_scale);
    self.sprite = -1;
    surface_set_target(self.surface);
    draw_clear_alpha(c_white, 1);
    surface_reset_target();
    
    self.brush_index = 7;
    
    static Reset = function(width, height) {
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        if (surface_exists(self.surface)) surface_free(self.surface);
        self.sprite = -1;
        self.surface = surface_create(width * Stuff.terrain.color_scale, height * Stuff.terrain.color_scale);
        surface_set_target(self.surface);
        draw_clear_alpha(c_white, 1);
        surface_reset_target();
    };
    static SaveState = function() {
        if (!surface_exists(self.surface)) return;
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
        self.sprite = sprite_create_from_surface(self.surface, 0, 0, surface_get_width(self.surface), surface_get_height(self.surface), false, false, 0, 0);
    };
    static LoadState = function() {
        if (!sprite_exists(self.sprite)) return;
        if (surface_exists(self.surface)) surface_free(self.surface);
        self.surface = sprite_to_surface(self.sprite, 0);
    };
    static Clear = function(color) {
        surface_set_target(self.surface);
        draw_clear_alpha(color, 1);
        surface_reset_target();
    };
    static Paint = function(x, y, radius, color) {
        if (!surface_exists(self.surface)) self.LoadState();
        surface_set_target(self.surface);
        shader_set(shd_terrain_paint);
        draw_sprite_ext(spr_terrain_default_brushes, clamp(self.brush_index, 0, sprite_get_number(spr_terrain_default_brushes) - 1), x, y, radius / 32, radius / 32, 0, color, Stuff.terrain.paint_strength);
        shader_reset();
        surface_reset_target();
    };
    static Finish = function() {
        self.SaveState();
    };
})();

self.terrain_buffer = vertex_create_buffer();
vertex_begin(self.terrain_buffer, self.vertex_format);

for (var i = 0; i < self.width - 1; i++) {
    for (var j = 0; j < self.height - 1; j++) {
        terrain_create_square(self.terrain_buffer, i, j, 0, 0, 0, 0);
    }
}

vertex_end(self.terrain_buffer);
self.terrain_buffer_data = buffer_create_from_vertex_buffer(self.terrain_buffer, buffer_fixed, 1);
vertex_freeze(self.terrain_buffer);

LoadAsset = function(directory) {
    directory += "/";
    buffer_delete(self.height_data);
    buffer_delete(self.terrain_buffer_data);
    try {
        self.height_data = buffer_load(directory + "height.terrain");
        self.terrain_buffer_data = buffer_load(directory + "terrain.terrain");
        self.terrain_buffer = vertex_create_buffer_from_buffer(self.terrain_buffer_data, self.vertex_format);
        vertex_freeze(self.terrain_buffer);
        self.color.sprite = sprite_add(directory + "color.png", 1, false, false, 0, 0);
        self.color.LoadState();
    } catch (e) {
        wtf("Could not load saved terrain data");
    }
};

SaveAsset = function(directory) {
    directory += "/";
    buffer_save(self.height_data, directory + "height.terrain");
    self.color.SaveState();
    if (sprite_exists(self.color.sprite)) sprite_save(self.color.sprite, 0, directory + "color.png");
    buffer_save(self.terrain_buffer_data, directory + "terrain.terrain");
};

LoadJSON = function(json) {
    self.width = json.width;
    self.height = json.height;
    self.dual_layer = json.settings.dual_layer;
};

CreateJSON = function() {
    return {
        width: self.width,
        height: self.height,
        dual_layer: self.dual_layer,
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
    for (var i = 0; i < ww * hh; i++) {
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

ClearTexture = function(tx, ty) {
    // we'll re-implement this later
    return;
    for (var i = 0; i < self.width - 1; i++) {
        for (var j = 0; j < self.height - 1; j++) {
            var index0 = terrain_get_vertex_index(self, i, j, 0);
            var index1 = index0 + VERTEX_SIZE;
            var index2 = index1 + VERTEX_SIZE;
            var index3 = index2 + VERTEX_SIZE;
            var index4 = index3 + VERTEX_SIZE;
            var index5 = index4 + VERTEX_SIZE;
            
            buffer_poke(self.terrain_buffer_data, index0 + 24, buffer_f32, tx);
            buffer_poke(self.terrain_buffer_data, index1 + 24, buffer_f32, tx + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index2 + 24, buffer_f32, tx + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index3 + 24, buffer_f32, tx + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index4 + 24, buffer_f32, tx);
            buffer_poke(self.terrain_buffer_data, index5 + 24, buffer_f32, tx);
            buffer_poke(self.terrain_buffer_data, index0 + 28, buffer_f32, ty);
            buffer_poke(self.terrain_buffer_data, index1 + 28, buffer_f32, ty);
            buffer_poke(self.terrain_buffer_data, index2 + 28, buffer_f32, ty + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index3 + 28, buffer_f32, ty + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index4 + 28, buffer_f32, ty + terrain_tile_size);
            buffer_poke(self.terrain_buffer_data, index5 + 28, buffer_f32, ty);
        }
    }
    
    terrain_refresh_vertex_buffer(self);
};

DrawWater = function(set_lights = true) {
    if (!self.view_water) return;
    
    if (set_lights) {
        graphics_set_lighting_terrain(shd_terrain_water);
    }
    
    var water_level = 512 * power(self.water_level, 3);
    matrix_set(matrix_world, matrix_build(0, 0, water_level, 0, 0, 0, 1, 1, 1));
    texture_set_stage(shader_get_sampler_index(shd_terrain_water, "displacementMap"), sprite_get_texture(spr_terrain_water_disp, 0));
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_WaterAlphaBounds"), 0.4, 0.9);
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Time"), current_time / 1000, current_time / 1000);
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Displacement"), 0.0625);
    vertex_submit(self.water, pr_trianglelist, sprite_get_texture(spr_terrain_water, 0));
    shader_reset();
};
#endregion

#region Export methods
AddToProject = function(name = "Terrain", density = 1, swap_zup = false, swap_uv = false) {
    var vbuff = self.BuildVertexBuffer(density, swap_zup, swap_uv);
    var mesh = new DataMesh(name);
    mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1), vbuff);
    array_push(Game.meshes, mesh);
    return mesh;
};

BuildVertexBuffer = function(density = 1, swap_zup = false, swap_uv = false) {
    density = floor(density);
    var scale = self.save_scale;
    var xoff = self.export_centered ? -self.width / 2 : 0;
    var yoff = self.export_centered ? -self.height / 2 : 0;
    
    var color_sprite = sprite_create_from_surface(self.color.surface, 0, 0, surface_get_width(self.color.surface), surface_get_height(self.color.surface), false, false, 0, 0);
    var sw = sprite_get_width(color_sprite) / self.color_scale;
    var sh = sprite_get_height(color_sprite) / self.color_scale;
    
    var vbuff = vertex_create_buffer();
    vertex_begin(vbuff, Stuff.graphics.vertex_format);
    
    for (var i = 0; i < self.width - density; i += density) {
        for (var j = 0; j < self.height - density; j += density) {
            var x00 = i;
            var y00 = j;
            var z00 = terrain_get_z(self, x00, y00);
            var x10 = i + density;
            var y10 = j;
            var z10 = terrain_get_z(self, x10, y10);
            var x11 = i + density;
            var y11 = j + density;
            var z11 = terrain_get_z(self, x11, y11);
            var x01 = i;
            var y01 = j + density;
            var z01 = terrain_get_z(self, x01, y01);
            
            /// @todo: calculate texture coordinates
            var xt00 = undefined;
            var yt00 = undefined;
            var c00 = undefined;
            var xt10 = undefined;
            var yt10 = undefined;
            var c10 = undefined;
            var xt11 = undefined;
            var yt11 = undefined;
            var c11 = undefined;
            var xt01 = undefined;
            var yt01 = undefined;
            var c01 = undefined;
            
            if (self.export_all || z00 > 0 || z10 > 0 || z11 > 0) {
                xt00 = 0;
                yt00 = 0;
                c00 = sprite_sample(color_sprite, 0, x00 / sw, y00 / sh);
                xt10 = 0;
                yt10 = 0;
                c10 = sprite_sample(color_sprite, 0, x10 / sw, y10 / sh);
                xt11 = 0;
                yt11 = 0;
                c11 = sprite_sample(color_sprite, 0, x11 / sw, y11 / sh);
                
                if (swap_uv) {
                    yt00 = 1 - yt00;
                    yt10 = 1 - yt10;
                    yt11 = 1 - yt11;
                }
                
                var norm = triangle_normal(x00, y00, z00, x10, y10, z10, x11, y11, z11);
                
                if (swap_zup) {
                    vertex_point_complete(vbuff, (x00 + xoff) * scale, z00 * scale, (y00 + yoff) * scale, norm[0], norm[2], norm[1], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x10 + xoff) * scale, z10 * scale, (y10 + yoff) * scale, norm[0], norm[2], norm[1], xt10, yt10, c10 & 0x00ffffff, (c10 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x11 + xoff) * scale, z11 * scale, (y11 + yoff) * scale, norm[0], norm[2], norm[1], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
                } else {
                    vertex_point_complete(vbuff, (x00 + xoff) * scale, (y00 + yoff) * scale, z00 * scale, norm[0], norm[1], norm[2], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x10 + xoff) * scale, (y10 + yoff) * scale, z10 * scale, norm[0], norm[1], norm[2], xt10, yt10, c10 & 0x00ffffff, (c10 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x11 + xoff) * scale, (y11 + yoff) * scale, z11 * scale, norm[0], norm[1], norm[2], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
                }
            }
            
            if (self.export_all || z11 > 0 || z01 > 0 || z00 > 0) {
                // 11 and 00 may have already been calculated so theres no point
                // in doing it again!
                if (xt11 == undefined) {
                    xt11 = 0;
                    yt11 = 0;
                    c11 = sprite_sample(color_sprite, 0, x11 / sw, y11 / sh);
                    if (swap_uv) yt11 = 1 - yt11;
                }
                xt01 = 0;
                yt01 = 0;
                c01 = sprite_sample(color_sprite, 0, x01 / sw, y01 / sh);
                if (swap_uv) yt01 = 1 - yt01;
                
                if (xt00 == undefined) {
                    xt00 = 0;
                    yt00 = 0;
                    c00 = sprite_sample(color_sprite, 0, x00 / sw, y00 / sh);
                    if (swap_uv) yt00 = 1 - yt00;
                }
                
                var norm = triangle_normal(x11, y11, z11, x01, y01, z01, x00, y00, z00);
                
                if (swap_zup) {
                    vertex_point_complete(vbuff, (x11 + xoff) * scale, z11 * scale, (y11 + yoff) * scale, norm[0], norm[2], norm[1], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x01 + xoff) * scale, z01 * scale, (y01 + yoff) * scale, norm[0], norm[2], norm[1], xt01, yt01, c01 & 0x00ffffff, (c01 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x00 + xoff) * scale, z00 * scale, (y00 + yoff) * scale, norm[0], norm[2], norm[1], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
                } else {
                    vertex_point_complete(vbuff, (x11 + xoff) * scale, (y11 + yoff) * scale, z11 * scale, norm[0], norm[1], norm[2], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x01 + xoff) * scale, (y01 + yoff) * scale, z01 * scale, norm[0], norm[1], norm[2], xt01, yt01, c01 & 0x00ffffff, (c01 >> 24) / 0xff);
                    vertex_point_complete(vbuff, (x00 + xoff) * scale, (y00 + yoff) * scale, z00 * scale, norm[0], norm[1], norm[2], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
                }
            }
        }
    }
    
    sprite_sample_remove_from_cache(color_sprite, 0);
    sprite_delete(color_sprite);
    vertex_end(vbuff);
    
    return vbuff;
};

ExportD3D = function(filename, density = 1) {
    var mesh = self.AddToProject("Terrain", density);
    export_d3d(filename, mesh);
    mesh.Destroy();
};

ExportOBJ = function(filename, density = 1) {
    var mesh = self.AddToProject("Terrain", density, self.export_swap_zup, self.export_swap_uvs);
    export_obj(filename, mesh, "DDD Terrain");
    mesh.Destroy();
}

ExportVbuff = function(filename, density = 1) {
    var mesh = self.AddToProject("Terrain", density);
    export_vb(filename, mesh, self.output_vertex_format);
    mesh.Destroy();
};

ExportHeightmap = function(filename, scale) {
    var buffer = buffer_create(buffer_sizeof(buffer_u32) * self.width * self.height, buffer_fixed, 1);
    buffer_seek(self.height_data, buffer_seek_start, 0);
    
    for (var i = 0; i < self.height; i++) {
        for (var j = 0; j < self.width; j++) {
            // in a perfect world i'd be using all 32 bits available of each
            // pixel, but it seems tradition for heightmap images to be 8-bit
            var zz = clamp(round(buffer_read(self.height_data, buffer_f32) * scale), 0, 255);
            var color = (zz | zz << 8 | zz << 16) | 0xff000000;
            buffer_write(buffer, buffer_u32, color);
        }
    }
    
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

submode_equation[TerrainSubmodes.MOUND] = function(terrain, x, y, dir, avg, dist) {
    terrain_add_z(terrain, x, y, dir * terrain.rate * dcos(max(1, dist)));
};
submode_equation[TerrainSubmodes.AVERAGE] = function(terrain, x, y, dir, avg, dist) {
    terrain_set_z(terrain, x, y, lerp(terrain_get_z(terrain, x, y), avg, terrain.rate / 20));
};
submode_equation[TerrainSubmodes.AVG_FLAT] = function(terrain, x, y, dir, avg, dist) {
    terrain_set_z(terrain, x, y, avg);
};
submode_equation[TerrainSubmodes.ZERO] = function(terrain, x, y, dir, avg, dist) {
    terrain_set_z(terrain, x, y, 0);
};

style_radius_coefficient[TerrainStyles.BLOCK] = 2.0;        // this will effectively fill the entire space
style_radius_coefficient[TerrainStyles.CIRCLE] = 1.0;       // an exact circle

lights = array_create(MAX_TERRAIN_LIGHTS);
#macro MAX_TERRAIN_LIGHTS 16
for (var i = 0; i < MAX_TERRAIN_LIGHTS; i++) {
    lights[@ i] =new EditorTerrainLightData("Light" + string(i));
}

lights[0].type = LightTypes.DIRECTIONAL;
lights[0].x = 1;
lights[0].y = 1;
lights[0].z = -1;

terrain_light_enabled = setting_get("terrain", "light_enabled", true);
terrain_light_ambient = setting_get("terrain", "light_ambient", c_black);

terrain_fog_enabled = setting_get("terrain", "fog_enabled", true);
terrain_fog_color = setting_get("terrain", "fog_color", c_white);
terrain_fog_start = setting_get("terrain", "fog_start", 1000);
terrain_fog_end = setting_get("terrain", "fog_end", 32000);

ui = ui_init_terrain(id);
mode_id = ModeIDs.TERRAIN;