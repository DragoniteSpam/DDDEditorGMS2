/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

// this can't change so it can't be TOTALLY automatic
list.entries = Stuff.event.active.nodes;

ui_render_list(list, xx, yy);