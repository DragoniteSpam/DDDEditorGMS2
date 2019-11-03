/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;

buffer_poke(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32, value);

if (xx > 0 && yy > 0) {
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 2) + 8, buffer_f32, value);
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3) + 8, buffer_f32, value);
}

if (xx < terrain.width && yy > 0) {
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy - 1, 4) + 8, buffer_f32, value);
}

if (xx > 0 && yy < terrain.height) {
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy, 1) + 8, buffer_f32, value);
}

if (xx < terrain.width && yy < terrain.height) {
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 0) + 8, buffer_f32, value);
    buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 5) + 8, buffer_f32, value);
}