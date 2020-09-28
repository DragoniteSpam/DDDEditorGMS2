/// @param xx
/// @param yy
/// @param zz
/// @param [map]
function map_get_grid_cell() {
    // Does not do a bounds check. That is your job.
    var xx = argument[0];
    var yy = argument[1];
    var zz = argument[2];
    var map_container = (argument_count > 3) ? argument[3] : Stuff.map.active_map;
    return map_container.contents.map_grid[# xx, yy][@ zz];
}