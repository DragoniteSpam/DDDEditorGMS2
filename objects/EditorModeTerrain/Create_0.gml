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
    Settings.terrain.export_swap_uvs = self.export_swap_uvs;
    Settings.terrain.export_swap_zup = self.export_swap_zup;
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
export_swap_uvs = setting_get("terrain", "export_swap_uvs", false);
export_swap_zup = setting_get("terrain", "export_swap_zup", false);
smooth_shading = false;
dual_layer = false;
orthographic = false;
orthographic_scale = 1;

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

LoadJSONTerrain = function(json) {
    self.width = json.width;
    self.height = json.height;
    
    self.export_all = json.settings.export_all;
    self.view_water = json.settings.view_water;
    self.export_swap_uvs = json.settings.export_swap_uvs;
    self.export_swap_zup = json.settings.export_swap_zup;
    self.smooth_shading = json.settings.smooth_shading;
    self.dual_layer = json.settings.dual_layer;
    self.view_scale = json.settings.view_scale;
    self.save_scale = json.settings.save_scale;
    self.rate = json.settings.rate;
    self.radius = json.settings.radius;
    self.mode = json.settings.mode;
    self.submode = json.settings.submode;
    self.style = json.settings.style;
    self.tile_brush_x = json.settings.tile_brush_x;
    self.tile_brush_y = json.settings.tile_brush_y;
    self.paint_color = json.settings.paint_color;
    self.paint_strength = json.settings.paint_strength;
};

LoadJSON = function(json) {
    self.LoadJSONTerrain(json);
};

CreateJSONTerrain = function() {
    return {
        width: self.width,
        height: self.height,
        
        settings: {
            export_all: self.export_all,
            view_water: self.view_water,
            export_swap_uvs: self.export_swap_uvs,
            export_swap_zup: self.export_swap_zup,
            smooth_shading: self.smooth_shading,
            dual_layer: self.dual_layer,
            view_scale: self.view_scale,
            save_scale: self.save_scale,
            rate: self.rate,
            radius: self.radius,
            mode: self.mode,
            submode: self.submode,
            style: self.style,
            tile_brush_x: self.tile_brush_x,
            tile_brush_y: self.tile_brush_y,
            paint_color: self.paint_color,
            paint_strength: self.paint_strength,
        },
    };
}

CreateJSON = function() {
    return self.CreateJSONTerrain();
};

#region terrain actions
Flatten = function() {
    buffer_fill(self.height_data, 0, buffer_f32, 0, buffer_get_size(self.height_data));
    for (var i = 8, n = buffer_get_size(self.terrain_buffer_data); i < n; i += VERTEX_SIZE_TERRAIN) {
        buffer_poke(self.terrain_buffer_data, i, buffer_f32, 0);
    }
    terrain_refresh_vertex_buffer(self);
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