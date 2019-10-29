/// @param EditorModeTerrain

var terrain = argument0;

control_terrain_3d(terrain);

shader_set(shd_basic);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightCount"), 1);
shader_set_uniform_f_array(shader_get_uniform(shd_basic, "lightPosition"), vector3(1, 1, -1));

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(get_active_tileset().master, 1));

shader_reset();

if (terrain.cursor_position != undefined) {
    var scale = terrain.view_scale * terrain.radius;
    transform_set(0, 0, 0, 0, 0, 0, scale, scale, scale);
    transform_add(
        terrain.cursor_position[vec2.xx] * terrain.view_scale, terrain.cursor_position[vec2.yy] * terrain.view_scale, 0,
        0, 0, 0, 1, 1, 1
    );
    vertex_submit(terrain.cylinder, pr_trianglelist, -1);
}

transform_reset();