/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;

var index_nw = [
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 0),
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 1),
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 2),
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3),
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 4),
    terrain_get_vertex_index(terrain, xx - 1, yy - 1, 5),
];

var index_ne = [
    -1,
    -1,
    -1,
    terrain_get_vertex_index(terrain, xx, yy - 1, 3),
    terrain_get_vertex_index(terrain, xx, yy - 1, 4),
    terrain_get_vertex_index(terrain, xx, yy - 1, 5),
];

var index_sw = [
    terrain_get_vertex_index(terrain, xx - 1, yy, 0),
    terrain_get_vertex_index(terrain, xx - 1, yy, 1),
    terrain_get_vertex_index(terrain, xx - 1, yy, 2),
    -1,
    -1,
    -1,
];

var index_se = [
    terrain_get_vertex_index(terrain, xx, yy, 0),
    terrain_get_vertex_index(terrain, xx, yy, 1),
    terrain_get_vertex_index(terrain, xx, yy, 2),
    terrain_get_vertex_index(terrain, xx, yy, 3),
    terrain_get_vertex_index(terrain, xx, yy, 4),
    terrain_get_vertex_index(terrain, xx, yy, 5),
];

buffer_poke(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32, value);

buffer_poke(terrain.terrain_buffer_data, index_nw[2] + 8, buffer_f32, value);
buffer_poke(terrain.terrain_buffer_data, index_nw[3] + 8, buffer_f32, value);
buffer_poke(terrain.terrain_buffer_data, index_ne[4] + 8, buffer_f32, value);
buffer_poke(terrain.terrain_buffer_data, index_sw[1] + 8, buffer_f32, value);
buffer_poke(terrain.terrain_buffer_data, index_se[0] + 8, buffer_f32, value);
buffer_poke(terrain.terrain_buffer_data, index_se[5] + 8, buffer_f32, value);

/*var normal_nw = triangle_normal(
    xx - 1, yy - 1, buffer_peek(terrain.terrain_buffer_data, indices[0], buffer_f32),
    xx, yy - 1, buffer_peek(terrain.terrain_buffer_data, indices[2], buffer_f32),
    xx - 1, yy, buffer_peek(terrain.terrain_buffer_data, indices[2], buffer_f32),
    xx, yy, buffer_peek(terrain.terrain_buffer_data, indices[2], buffer_f32)
);*/