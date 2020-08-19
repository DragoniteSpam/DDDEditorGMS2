/// @param xx
/// @param yy
/// @param zz
/// @param slot
function map_get_free_at(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var slot = argument3;

    /// @gml chained accessors
    var thing = Stuff.map.active_map.contents.map_grid[# xx, yy];
    var cell = thing[@ zz];

    return cell[@ slot] == noone;


}
