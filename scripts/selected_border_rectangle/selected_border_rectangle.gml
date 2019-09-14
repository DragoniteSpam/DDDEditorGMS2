/// @param selection
/// @param Entity

var selection = argument0;
var entity = argument1;

var minx = min(selection.x1, selection.x2) - 1;
var miny = min(selection.y1, selection.y2) - 1;
var minz = min(selection.z1, selection.z2) - 1;
var maxx = max(selection.x1, selection.x2) + 1;
var maxy = max(selection.y1, selection.y2) + 1;
var maxz = max(selection.z1, selection.z2) + 1;

// exclude the outer edge but don't have a negative area
var maxex = max(minx, maxx - 1);
var maxey = max(miny, maxy - 1);
var maxez = max(minz, maxz - 1);

return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Stuff.active_map.contents.is_3d || is_clamped(entity.zz, minz, maxez));