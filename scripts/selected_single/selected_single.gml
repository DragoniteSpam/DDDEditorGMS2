/// @param selection
/// @param Entity

var selection = argument0;
var entity = argument1;

return (selection.x == entity.xx && selection.y == entity.yy) && (!Stuff.active_map.is_3d || selection.z == entity.zz);