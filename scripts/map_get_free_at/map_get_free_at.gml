/// @param xx
/// @param yy
/// @param zz
/// @param slot

var xx = argument0;
var yy = argument1;
var zz = argument2;
var slot = argument3;

var thing = Stuff.map.active_map.contents.map_grid[# xx, yy];
var cell = thing[@ zz];

return cell[@ slot] == noone;