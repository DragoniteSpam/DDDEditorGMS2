/// @param terrain
/// @param x
/// @param y
/// @param value
function terrain_set_color(argument0, argument1, argument2, argument3) {

    var terrain = argument0;
    var xx = argument1;
    var yy = argument2;
    var value = argument3;

    buffer_poke(terrain.color_data, terrain_get_color_index(terrain, xx, yy), buffer_u32, value);

    if (xx > 0 && yy > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 2) + 32, buffer_u32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3) + 32, buffer_u32, value);
    }

    if (xx < terrain.width && yy > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy - 1, 4) + 32, buffer_u32, value);
    }

    if (xx > 0 && yy < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy, 1) + 32, buffer_u32, value);
    }

    if (xx < terrain.width && yy < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 0) + 32, buffer_u32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 5) + 32, buffer_u32, value);
    }


}
