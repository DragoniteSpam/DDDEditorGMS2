event_inherited();
var t = get_timer();
render = terrain_editor_render;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format = vertex_format_end();

height = 1024;
width = 1024;

view_scale = 32;
save_scale = 1;

texture_size = 32 / 2048;
texel = 1 / 2048;

terrain_buffer = vertex_create_buffer();
vertex_begin(terrain_buffer, vertex_format);

for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
        terrain_create_square(terrain_buffer, i, j, 0, 0, texture_size, texel);
    }
}

vertex_end(terrain_buffer);
terrain_buffer_data = buffer_create_from_vertex_buffer(terrain_buffer, buffer_fixed, 1);
vertex_freeze(terrain_buffer);

debug("Terrain creation took " + string((get_timer() - t) / 1000) + " milliseconds");