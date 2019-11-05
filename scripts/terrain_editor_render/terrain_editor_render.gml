/// @param EditorModeTerrain

var terrain = argument0;

if (mouse_within_view(view_3d) && !dialog_exists()) {
    if (terrain.orthographic) {
        control_terrain_3d_ortho(terrain);
    } else {
        control_terrain_3d(terrain);
    }
}

if (terrain.view_water) {
    graphics_draw_water();
}

shader_set(shd_basic);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightCount"), 1);
shader_set_uniform_f_array(shader_get_uniform(shd_basic, "lightData"), [
	1, 1, -1, 0,
		0, 0, 0, 0,
		1, 1, 1, 0,
]);

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(terrain.texture, 0));

shader_reset();
/*
if (terrain.cursor_position != undefined && terrain.view_cylinder) {
    var scale = terrain.view_scale * terrain.radius;
    transform_set(0, 0, 0, 0, 0, 0, scale, scale, scale);
    transform_add(
        terrain.cursor_position[vec2.xx] * terrain.view_scale, terrain.cursor_position[vec2.yy] * terrain.view_scale,
		0, 0, 0, 0, 1, 1, 1
    );
    vertex_submit(Stuff.basic_cylinder, pr_trianglelist, -1);
}
*/
transform_reset();