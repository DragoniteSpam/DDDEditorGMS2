/// @param UIThing
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

draw_rectangle_colour(
    xx + thing.x1, yy + thing.y1, xx + thing.x2, yy + thing.y2,
    thing.color, thing.color, thing.color, thing.color, thing.outline
);

ui_handle_dropped_files(thing);