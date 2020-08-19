/// @param terrain
/// @param x
/// @param y
function terrain_get_color(argument0, argument1, argument2) {

    var terrain = argument0;
    var xx = argument1;
    var yy = argument2;
    var index = terrain_get_color_index(terrain, xx, yy);

    return buffer_peek(terrain.color_data, index, buffer_u32);


}
