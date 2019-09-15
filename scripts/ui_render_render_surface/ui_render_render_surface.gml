/// @param UIRenderSurface
/// @param x
/// @param y

var surface = argument0;
var xx = argument1;
var yy = argument2;

var x1 = surface.x + xx;
var y1 = surface.y + yy;
var x2 = x1 + surface.width;
var y2 = y1 + surface.height;

surface_set_target(surface.surface);
script_execute(surface.script_render);
surface_reset_target();
script_execute(surface.script_control);

draw_surface(surface.surface, x1, y1);