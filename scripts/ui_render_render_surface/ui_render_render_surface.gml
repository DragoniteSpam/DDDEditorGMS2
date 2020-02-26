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

if (!surface_exists(surface.surface)) {
    surface.surface = surface_create(surface.width, surface.height);
}

surface_set_target(surface.surface);
script_execute(surface.script_render, surface, x1, y1, x2, y2);
surface_reset_target();
script_execute(surface.script_control, surface, x1, y1, x2, y2);

draw_surface(surface.surface, x1, y1);