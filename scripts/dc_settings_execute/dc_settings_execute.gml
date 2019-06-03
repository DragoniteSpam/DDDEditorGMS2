/// @description void dc_settings_execute(Dialog);
/// @param Dialog
// Actually commits the settings. Only call this when you know it's
// safe to do so. Failing to do so will probably result in a memory leak.

var map=argument0.data;

var xx=ActiveMap.xx;
var yy=ActiveMap.yy;
var zz=ActiveMap.zz;

if (ds_map_exists(map, "x")) {
    xx=map[? "x"];
}
if (ds_map_exists(map, "y")) {
    yy=map[? "y"];
}
if (ds_map_exists(map, "z")) {
    zz=map[? "z"];
}

data_resize_map(xx, yy, zz);
