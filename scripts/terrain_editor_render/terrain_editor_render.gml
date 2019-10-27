/// @param EditorModeTerrain

var terrain = argument0;

control_terrain_3d(terrain);

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(get_active_tileset().master, 1));

if (terrain.cursor_position != undefined) {
    transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
    transform_add(
        terrain.cursor_position[vec2.xx] * terrain.view_scale, terrain.cursor_position[vec2.yy] * terrain.view_scale, 0,
        0, 0, 0, 1, 1, 1
    );
    vertex_submit(terrain.cylinder, pr_trianglelist, -1);
}

transform_reset();