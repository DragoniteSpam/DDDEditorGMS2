/// @param EditorModeTerrain

var terrain = argument0;

control_terrain_3d(terrain);

shader_set(shd_basic);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightCount"), 4);
shader_set_uniform_f_array(shader_get_uniform(shd_basic, "lightData"), [
	1000, 1000, 256, 1,
		2048, 0, 0, 0,
		0.8, 0, 0, 1,
	1600, 1000, 320, 1,
		2048, 0, 0, 0,
		0, 0.8, 0, 1,
	1400, 1200, 360, 1,
		2048, 0, 0, 0,
		0.8, 0, 0.8, 1,
	1960, 1800, 240, 1,
		2048, 0, 0, 0,
		0.5, 0.5, 1, 1,
]);

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(get_active_tileset().master, 1));

shader_reset();

if (terrain.cursor_position != undefined) {
    var scale = terrain.view_scale * terrain.radius;
    transform_set(0, 0, 0, 0, 0, 0, scale, scale, scale);
    transform_add(
        terrain.cursor_position[vec2.xx] * terrain.view_scale, terrain.cursor_position[vec2.yy] * terrain.view_scale,
		0, 0, 0, 0, 1, 1, 1
    );
    vertex_submit(Stuff.basic_cylinder, pr_trianglelist, -1);
}

transform_reset();