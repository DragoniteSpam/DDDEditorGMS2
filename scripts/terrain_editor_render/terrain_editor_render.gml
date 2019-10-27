/// @param EditorModeTerrain

var terrain = argument0;

control_terrain_3d(terrain);

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(get_active_tileset().master, 1));
transform_reset();