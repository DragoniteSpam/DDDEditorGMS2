/// @param EntityEffect
/// @param xx
/// @param yy
/// @param zz

var effect = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;

var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_add(map_contents.all_entities, effect);
ds_list_add(map_contents.dynamic, effect);