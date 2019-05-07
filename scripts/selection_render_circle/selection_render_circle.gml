transform_set(0, 0, argument0.z*TILE_DEPTH, 0, 0, 0, 1, 1, 1);

var precision=24;
var step=360/precision;
var cx=argument0.x*TILE_WIDTH;
var cy=argument0.y*TILE_HEIGHT;
var cz=argument0.z*TILE_DEPTH;
var rw=argument0.radius*TILE_WIDTH;
var rh=argument0.radius*TILE_HEIGHT;
var rd=argument0.radius*TILE_DEPTH;
var w=12;

for (var i=0; i<precision; i++){
    var angle=i*step;
    var angle2=(i+1)*step;
    draw_line_width_colour(cx+rw*dcos(angle), cy-rh*dsin(angle), cx+rw*dcos(angle2), cy-rh*dsin(angle2), w, c_red, c_red);
}

transform_reset();
