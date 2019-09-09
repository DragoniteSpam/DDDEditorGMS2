/// @param Dialog
// Actually commits the settings. Only call this when you know it's
// safe to do so. Failing to do so will probably result in a memory leak.

var dialog = argument0;
var data_map = dialog.data;
var map = Stuff.active_map;

var xx = map.xx;
var yy = map.yy;
var zz = map.zz;

if (ds_map_exists(map, "x")) {
    xx = data_map[? "x"];
}
if (ds_map_exists(map, "y")) {
    yy = data_map[? "y"];
}
if (ds_map_exists(map, "z")) {
    zz = data_map[? "z"];
}

data_resize_map(xx, yy, zz);