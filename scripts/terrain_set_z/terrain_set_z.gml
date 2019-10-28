/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;

var indices = [
    terrain.format_size * (((xx - 1) * terrain.height + (yy - 1)) * terrain.vertices_per_square + 2),
    terrain.format_size * (((xx - 1) * terrain.height + (yy - 1)) * terrain.vertices_per_square + 3),
    terrain.format_size * ((xx * terrain.height + (yy - 1)) * terrain.vertices_per_square + 4),
    terrain.format_size * (((xx - 1) * terrain.height + yy) * terrain.vertices_per_square + 1),
    terrain.format_size * (xx * terrain.height + yy) * terrain.vertices_per_square,
    terrain.format_size * ((xx * terrain.height + yy) * terrain.vertices_per_square + 5),
]

for (var i = 0; i < array_length_1d(indices); i++) {
    if (is_clamped(indices[i], 0, buffer_get_size(terrain.terrain_buffer_data))) {
        buffer_poke(terrain.terrain_buffer_data, indices[i] + 8, buffer_f32, value);
    }
}