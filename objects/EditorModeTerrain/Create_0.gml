event_inherited();

var camera = view_get_camera(view_3d);
depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));

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
};

texture_name = DEFAULT_TILESET;
texture = sprite_add(PATH_GRAPHICS + texture_name, 0, false, false, 0, 0);

vertices_per_square = 6;

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;

view_scale = 32;
save_scale = 1;
export_all = false;
view_water = true;
export_swap_uvs = false;
export_swap_zup = false;
smooth_shading = false;
dual_layer = false;
orthographic = false;
orthographic_scale = 1;

cursor_position = undefined;
// height defaults
brush_min = 1.5;
brush_max = 8;
rate_min = 0.02;
rate_max = 1;
// height settings
rate = 0.125;
radius = 4;
mode = TerrainModes.Z;
submode = TerrainSubmodes.MOUND;
style = TerrainStyles.CIRCLE;
// texture defautls
tile_size = 32 / texture_width;
texel = 1 / 4096;
// texture settings
tile_brush_x = 32 / 4096;
tile_brush_y = 32 / 4096;
// paint defaults
paint_strength_min = 0.01;
paint_strength_max = 1;
// paint settings
paint_color = 0xffffffff;
paint_strength = 0.05;

var t = get_timer();

height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
color_data = buffer_create(buffer_sizeof(buffer_u32) * width * height, buffer_fixed, 1);
buffer_fill(color_data, 0, buffer_u32, 0xffffffff, buffer_get_size(color_data));
// you don't need a texture UV buffer, since that will only be set and not mutated

terrain_buffer = vertex_create_buffer();
vertex_begin(terrain_buffer, Stuff.graphics.vertex_format);

for (var i = 0; i < width - 1; i++) {
    for (var j = 0; j < height - 1; j++) {
        terrain_create_square(terrain_buffer, i, j, 1, 0, 0, tile_size, texel);
    }
}

vertex_end(terrain_buffer);
terrain_buffer_data = buffer_create_from_vertex_buffer(terrain_buffer, buffer_fixed, 1);
vertex_freeze(terrain_buffer);

LoadAsset = function(directory) {
    directory += "/";
    buffer_delete(self.height_data);
    buffer_delete(self.color_data);
    buffer_delete(self.terrain_buffer_data);
    self.height_data = buffer_load(directory + "height.terrain");
    self.color_data = buffer_load(directory + "color.terrain");
    self.terrain_buffer_data = buffer_load(directory + "terrain.terrain");
    self.terrain_buffer = vertex_create_buffer_from_buffer(self.terrain_buffer_data, Stuff.graphics.vertex_format);
};

SaveAsset = function(directory) {
    directory += "/";
    buffer_save(self.height_data, directory + "height.terrain");
    buffer_save(self.color_data, directory + "color.terrain");
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