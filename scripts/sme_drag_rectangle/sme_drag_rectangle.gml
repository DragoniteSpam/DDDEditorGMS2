/// @param Selection
/// @param x
/// @param y
// MAYBE if there's an object under the cursor you want to expand the
// selection on the x axis too, but deal with that later.

var selection = argument0;
var xx = argument1;
var yy = argument2;

selection.x2 = xx;
selection.y2 = yy;

sa_process_selection();