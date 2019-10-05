/// @param SelectionSingle

var selection = argument0;

transform_set(0, 0, selection.z * TILE_DEPTH + 1, 0, 0, 0, 1, 1, 1);

var x1 = selection.x * TILE_WIDTH;
var y1 = selection.y * TILE_HEIGHT;
var x2 = (selection.x + 1) * TILE_WIDTH;
var y2 = (selection.y + 1) * TILE_HEIGHT;

var w = 12;

draw_line_width_colour(x1, y1, x1, y2, w, c_red, c_red);
draw_line_width_colour(x1, y1, x2, y1, w, c_red, c_red);
draw_line_width_colour(x2, y1, x2, y2, w, c_red, c_red);
draw_line_width_colour(x1, y2, x2, y2, w, c_red, c_red);
transform_reset();