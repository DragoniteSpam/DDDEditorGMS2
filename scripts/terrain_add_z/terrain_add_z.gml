/// @param terrain
/// @param x
/// @param y
/// @param value
function terrain_add_z(argument0, argument1, argument2, argument3) {

    var terrain = argument0;
    var xx = argument1;
    var yy = argument2;
    var value = argument3;
    var existing = terrain_get_z(terrain, xx, yy);

    terrain_set_z(terrain, xx, yy, existing + value);


}
