/// @param xx
/// @param yy
/// @param zz
/// @param tag
/// @param [map]
function map_set_tag_grid() {
    var xx = argument[0];
    var yy = argument[1];
    var zz = argument[2];
    var tag = argument[3];
    var map = (argument_count > 4) ? argument[4] : Stuff.map.active_map;
    map.contents.map_grid_frozen_tags[# xx, yy][@ zz] = tag;
}