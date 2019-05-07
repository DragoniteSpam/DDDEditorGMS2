transform_set(0, 0, argument0.z*TILE_DEPTH, 0, 0, 0, 1, 1, 1);

var x1=argument0.x*TILE_WIDTH;
var y1=argument0.y*TILE_HEIGHT;
var x2=(argument0.x+1)*TILE_WIDTH;
var y2=(argument0.y+1)*TILE_HEIGHT;

var w=12;

draw_line_width_colour(x1, y1, x1, y2, w, c_red, c_red);
draw_line_width_colour(x1, y1, x2, y1, w, c_red, c_red);
draw_line_width_colour(x2, y1, x2, y2, w, c_red, c_red);
draw_line_width_colour(x1, y2, x2, y2, w, c_red, c_red);
transform_reset();
