/// @param EditorModeMap

var mode = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;

draw_clear(c_black);

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_counterclockwise);
draw_set_color(c_white);