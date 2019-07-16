/// @param xx
/// @param yy
/// @param zz
/// @param slot

var thing = ActiveMap.map_grid[# argument0, argument1];
var cell = thing[@ argument2];

return cell[@ argument3] == noone;