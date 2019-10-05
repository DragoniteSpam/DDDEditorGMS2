/// @param Selection
/// @param x
/// @param y

var selection = argument0;
var xx = argument1;
var yy = argument2;

selection.radius = floor(point_distance(selection.x, selection.y, xx, yy));

sa_process_selection();