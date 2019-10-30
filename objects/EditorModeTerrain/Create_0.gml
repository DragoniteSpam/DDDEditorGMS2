event_inherited();
var t = get_timer();
render = terrain_editor_render;

vertices_per_square = 6;
format_size = 0;

vertex_format_begin();
vertex_format_add_position_3d();
format_size = format_size + 4 * 3;
vertex_format_add_normal();
format_size = format_size + 4 * 3;
vertex_format_add_texcoord();
format_size = format_size + 4 * 2;
vertex_format_add_colour();
format_size = format_size + 4;
vertex_format = vertex_format_end();

cursor_position = undefined;
rate = 0.125;
radius = 4;
mode = TerrainModes.Z;
submode = TerrainSubmodes.MOUND;
style = TerrainStyles.ROUND_BLOCK;

height = 256;
width = 256;

view_scale = 32;
save_scale = 1;
save_under_z_0 = true;
view_water = true;

texture_size = 32 / 2048;
texel = 1 / 2048;

height_data = buffer_create(4 * width * height, buffer_fixed, 1);

terrain_buffer = vertex_create_buffer();
vertex_begin(terrain_buffer, vertex_format);

for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        terrain_create_square(terrain_buffer, i, j, buffer_peek(height_data, i * height + j, buffer_f32), 0, 0, texture_size, texel);
    }
}

vertex_end(terrain_buffer);
terrain_buffer_data = buffer_create_from_vertex_buffer(terrain_buffer, buffer_fixed, 1);
vertex_freeze(terrain_buffer);

debug("Terrain creation took " + string((get_timer() - t) / 1000) + " milliseconds");

enum TerrainModes {
    Z,
    TEXTURE,
    COLOR,
}

enum TerrainSubmodes {
    MOUND,
    SHARP,
    AVERAGE,
    AVG_FLAT,
    ZERO,
    TEXTURE,
    COLOR,
}

enum TerrainStyles {
    BLOCK,
    CIRCLE,
    ROUND_BLOCK,
}

submode_equation[TerrainSubmodes.MOUND] = terrain_sub_mound;
submode_equation[TerrainSubmodes.SHARP] = terrain_sub_sharp;
submode_equation[TerrainSubmodes.AVERAGE] = terrain_sub_avg;
submode_equation[TerrainSubmodes.AVG_FLAT] = terrain_sub_flat;
submode_equation[TerrainSubmodes.ZERO] = terrain_sub_zero;

style_radius_coefficient[TerrainStyles.CIRCLE] = 1.0;
style_radius_coefficient[TerrainStyles.BLOCK] = 2.0;
style_radius_coefficient[TerrainStyles.ROUND_BLOCK] = 1.2;