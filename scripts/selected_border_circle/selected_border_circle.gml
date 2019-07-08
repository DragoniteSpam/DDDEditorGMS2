/// @param selection
/// @param Entity

var minx = argument0.x - 1 - radius;
var miny = argument0.y - 1 - radius;
var minz = argument0.z - 1 - radius;
var maxx = argument0.x + 1 + radius;
var maxy = argument0.y + 1 + radius;
var maxz = argument0.z + 1 + radius;

return is_clamped(argument1.xx, minx, maxx) && is_clamped(argument1.yy, miny, maxy) && is_clamped(argument1.zz, minz, maxz);