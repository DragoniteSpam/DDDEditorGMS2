/// @param selection
/// @param Entity

// since you don't know if start and end are in the correct
// order, you have to put them in the correct order
var minx = argument0.x - 1;
var miny = argument0.y - 1;
var minz = argument0.z - 1;
var maxx = argument0.x + 1;
var maxy = argument0.y + 1;
var maxz = argument0.z + 1;

return is_clamped(argument1.xx, minx, maxx) && is_clamped(argument1.yy, miny, maxy) && is_clamped(argument1.zz, minz, maxz);