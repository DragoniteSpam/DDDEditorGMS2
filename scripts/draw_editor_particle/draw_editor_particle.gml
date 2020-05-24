/// @param EditorModeParticle

var mode = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;
var camera = camera_get_active();

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_counterclockwise);
transform_set(0, 0, 0, 0, 0, 0, 1, 1, 1);

draw_clear(mode.back_color);
vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
draw_set_alpha(0.75);
draw_set_color(mode.back_color);
draw_rectangle(0, 0, camera_get_view_width(camera), camera_get_view_height(camera), false);
draw_set_color(c_white);
draw_set_alpha(1);

part_system_drawit(mode.system);