/// @param selection
/// @param Entity

var selection = argument0;
var entity = argument1;

var minx = selection.x - 1 - selection.radius;
var miny = selection.y - 1 - selection.radius;
var minz = selection.z - 1 - selection.radius;
var maxx = selection.x + 1 + selection.radius;
var maxy = selection.y + 1 + selection.radius;
var maxz = selection.z + 1 + selection.radius;

return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d && is_clamped(entity.zz, minz, maxz));