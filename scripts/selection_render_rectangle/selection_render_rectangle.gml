var z1=argument0.z1*TILE_DEPTH;
var z2=argument0.z2*TILE_DEPTH;

transform_set(0, 0, z1, 0, 0, 0, 1, 1, 1);

var x1=argument0.x1*TILE_WIDTH;
var y1=argument0.y1*TILE_HEIGHT;
var x2=argument0.x2*TILE_WIDTH;
var y2=argument0.y2*TILE_HEIGHT;
var w=12;

// bottom box
draw_line_width_colour(x1, y1, x1, y2, w, c_red, c_red);
draw_line_width_colour(x1, y1, x2, y1, w, c_red, c_red);
draw_line_width_colour(x2, y1, x2, y2, w, c_red, c_red);
draw_line_width_colour(x1, y2, x2, y2, w, c_red, c_red);

/*
if (z2!=z1){
    // top box
    transform_add(0, 0, z2-z1, 0, 0, 0, 1, 1, 1);
    
    draw_line_width_colour(x1, y1, x1, y2, w, c_red, c_red);
    draw_line_width_colour(x1, y1, x2, y1, w, c_red, c_red);
    draw_line_width_colour(x2, y1, x2, y2, w, c_red, c_red);
    draw_line_width_colour(x1, y2, x2, y2, w, c_red, c_red);
    
    // pillars
}*/

transform_reset();
