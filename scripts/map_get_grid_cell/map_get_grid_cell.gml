/// @param xx
/// @param yy
/// @param zz
// Does not do a bounds check. That is your job.

var xx = argument0;
var yy = argument1;
var zz = argument2;

var thing = Stuff.active_map.contents.map_grid[# xx, yy];
return thing[@ zz];