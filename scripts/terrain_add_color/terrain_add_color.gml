/// @param terrain
/// @param x
/// @param y
/// @param color
/// @param strength
function terrain_add_color(argument0, argument1, argument2, argument3, argument4) {

    var terrain = argument0;
    var xx = argument1;
    var yy = argument2;
    var color = argument3;
    var strength = argument4;
    var existing = terrain_get_color(terrain, xx, yy);

    terrain_set_color(terrain, xx, yy, merge_colour_ds(existing, color, strength));


}
