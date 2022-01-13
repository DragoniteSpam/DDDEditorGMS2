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
    // camera settings
    Settings.terrain.x = self.x;
    Settings.terrain.y = self.y;
    Settings.terrain.z = self.z;
    Settings.terrain.xto = self.xto;
    Settings.terrain.yto = self.yto;
    Settings.terrain.zto = self.zto;
    Settings.terrain.fov = self.fov;
    // viewer settings
    Settings.terrain.view_water = self.view_water;
    Settings.terrain.view_water_min_alpha = self.view_water_min_alpha;
    Settings.terrain.view_water_max_alpha = self.view_water_max_alpha;
    Settings.terrain.water_level = self.water_level;
    Settings.terrain.view_grid = self.view_grid;
    Settings.terrain.view_axes = self.view_axes;
    // export settings
    Settings.terrain.save_scale = self.save_scale;
    Settings.terrain.export_all = self.export_all;
    Settings.terrain.heightmap_scale = self.heightmap_scale;
    Settings.terrain.export_swap_uvs = self.export_swap_uvs;
    Settings.terrain.export_swap_zup = self.export_swap_zup;
    Settings.terrain.export_centered = self.export_centered;
    Settings.terrain.export_chunk_size = self.export_chunk_size;
    Settings.terrain.export_smooth = self.export_smooth;
    Settings.terrain.export_smooth_threshold = self.export_smooth_threshold;
    Settings.terrain.output_vertex_format = self.output_vertex_format;
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
texture = sprite_add(PATH_GRAPHICS + texture_name, 0, false, false, 0, 0);

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;
color_scale = 8;

view_scale = 4;
save_scale = setting_get("terrain", "save_scale", 1);
export_all = setting_get("terrain", "export_all", false);
view_water = setting_get("terrain", "view_water", true);
view_water_min_alpha = setting_get("terrain", "view_water_min_alpha", 0.5);
view_water_max_alpha = setting_get("terrain", "view_water_max_alpha", 0.9);
water_level = setting_get("terrain", "water_level", -0.2);
view_grid = setting_get("terrain", "view_grid", true);
view_axes = setting_get("terrain", "view_axes", true);
heightmap_scale = setting_get("terrain", "heightmap_scale", 10);
export_swap_uvs = setting_get("terrain", "export_swap_uvs", false);
export_swap_zup = setting_get("terrain", "export_swap_zup", false);
export_centered = setting_get("terrain", "export_centered", false);
export_chunk_size = setting_get("terrain", "export_chunk_size", 64);
export_smooth = setting_get("terrain", "export_smooth", false);
export_smooth_threshold = setting_get("terrain", "export_smooth_threshold", 60);
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

color = new Painter(Stuff.terrain.width * Stuff.terrain.color_scale, Stuff.terrain.height * Stuff.terrain.color_scale);

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

SetTexture = function(x, y, tx, ty) {
    // we'll re-implement this later
    return;
    terrain_refresh_vertex_buffer(self);
};

ClearTexture = function(tx, ty) {
    // we'll re-implement this later
    return;
    terrain_refresh_vertex_buffer(self);
};

DrawWater = function(set_lights = true) {
    if (!self.view_water) return;
    
    if (set_lights) {
        graphics_set_lighting_terrain(shd_terrain_water);
    }
    
    var water_level = 512 * power(self.water_level, 3);
    gpu_set_cullmode(cull_noculling);
    texture_set_stage(shader_get_sampler_index(shd_terrain_water, "displacementMap"), sprite_get_texture(spr_terrain_water_disp, 0));
    var mn = min(self.view_water_min_alpha, self.view_water_max_alpha);
    var mx = max(self.view_water_min_alpha, self.view_water_max_alpha);
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_WaterAlphaBounds"), mn, mx);
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Time"), current_time / 1000, current_time / 1000);
    shader_set_uniform_f(shader_get_uniform(shd_terrain_water, "u_Displacement"), 0.0625);
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
    var output = terrainops_build(self.height_data, self.width, self.height, VERTEX_SIZE, self.export_all, self.export_swap_zup, self.export_swap_uvs, self.export_centered, density, self.save_scale);
    
    sprite_sample_remove_from_cache(color_sprite, 0);
    sprite_delete(color_sprite);
    
    if (Stuff.terrain.export_smooth) {
        meshops_set_normals_smooth(buffer_get_address(output), buffer_get_size(output), dcos(Stuff.terrain.export_smooth_threshold));
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
    var mesh = self.AddToProject("Terrain", density, self.export_swap_zup, self.export_swap_uvs, chunk_size);
    export_obj(filename, mesh, "DDD Terrain");
    mesh.Destroy();
}

ExportVbuff = function(filename, density = 1, chunk_size = 0) {
    var mesh = self.AddToProject("Terrain", density, false, false, chunk_size);
    export_vb(filename, mesh, self.output_vertex_format);
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