/// @param xx
/// @param yy
/// @param zz
function map_get_tag_grid(argument0, argument1, argument2) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var map_contents = Stuff.map.active_map.contents;

    /// @gml chained accessors
    var column = map_contents.map_grid_frozen_tags[# xx, yy];
    return column[@ zz];


}
