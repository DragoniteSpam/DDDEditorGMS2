event_inherited();

render = terrain_editor_render;

vertices_per_square = 6;
format_size = 0;

vertex_format_begin();
vertex_format_add_position_3d();
format_size = format_size + buffer_sizeof(buffer_f32) * 3;
vertex_format_add_normal();
format_size = format_size + buffer_sizeof(buffer_f32) * 3;
vertex_format_add_texcoord();
format_size = format_size + buffer_sizeof(buffer_f32) * 2;
vertex_format_add_colour();
format_size = format_size + buffer_sizeof(buffer_u32);
vertex_format = vertex_format_end();

brush_min = 2;
brush_max = 8;

rate_min = 0.02;
rate_max = 1;

paint_strength_min = 0.01;
paint_strength_max = 1;

cursor_position = undefined;
rate = 0.125;
radius = 4;
mode = TerrainModes.Z;
submode = TerrainSubmodes.MOUND;
style = TerrainStyles.ROUND_BLOCK;
tile_brush_x = 32 / 4096;
tile_brush_y = 32 / 4096;
paint_color = 0xffffffff;

tile_size = 32 / 4096;
texel = 1 / 4096;

paint_strength = 0.025;

height = 256;
width = 256;

view_scale = 32;
save_scale = 1;
export_all = false;
view_water = true;
export_swap_uvs = false;
export_swap_zup = false;

var t = get_timer();

height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
color_data = buffer_create(buffer_sizeof(buffer_u32) * width * height, buffer_fixed, 1);
buffer_fill(color_data, 0, buffer_u32, 0xffffffff, buffer_get_size(color_data));
// you don't need a texture UV buffer, since that will only be set and not mutated

terrain_buffer = vertex_create_buffer();
vertex_begin(terrain_buffer, vertex_format);

for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        terrain_create_square(terrain_buffer, i, j, buffer_peek(height_data, i * height + j, buffer_f32), 0, 0, tile_size, texel);
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
submode_equation[TerrainSubmodes.AVERAGE] = terrain_sub_avg;
submode_equation[TerrainSubmodes.AVG_FLAT] = terrain_sub_flat;
submode_equation[TerrainSubmodes.ZERO] = terrain_sub_zero;

style_radius_coefficient[TerrainStyles.CIRCLE] = 1.0;       // an exact circle
style_radius_coefficient[TerrainStyles.BLOCK] = 2.0;        // this will effectively fill the entire space
style_radius_coefficient[TerrainStyles.ROUND_BLOCK] = 1.2;  // a circle but with the extremities cut off