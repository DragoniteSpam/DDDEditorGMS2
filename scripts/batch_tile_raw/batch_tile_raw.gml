/// @param buffer
/// @param wireframe-buffer
/// @param x
/// @param y
/// @param z
/// @param tile_x
/// @param tile_y
/// @param color
/// @param alpha
/// @param [x-offset]
/// @param [y-offset]
/// @param [z-offset]

// this is much like batch_tile, except it bypasses the part where it actually needs an EntityTile,
// and also writes the data straight into a regular buffer instead of a vertex buffer

var buffer = argument[0];
var wire = argument[1];
var xx = argument[2] * TILE_WIDTH;
var yy = argument[3] * TILE_HEIGHT;
var zz = argument[4] * TILE_DEPTH;
var tile_x = argument[5];
var tile_y = argument[6];
var color = argument[7];
var alpha = argument[8];
var xoffset = (argument_count > 9 && argument[9] != undefined) ? argument[9] : 0;
var yoffset = (argument_count > 10 && argument[10] != undefined) ? argument[10] : 0;
var zoffset = (argument_count > 11 && argument[11] != undefined) ? argument[11] : 0;
var TEXEL = 1 / TEXTURE_SIZE;

xx = xx + xoffset;
yy = yy + yoffset;
zz = zz + zoffset;

var nx = 0;
var ny = 0;
var nz = 1;

var tile_horizontal_count = TEXTURE_SIZE / Stuff.tile_size;
var tile_vertical_count = TEXTURE_SIZE / Stuff.tile_size;

var texture_width = 1 / tile_horizontal_count;
var texture_height = 1 / tile_vertical_count;

var xtex = tile_x * texture_width;
var ytex = tile_y * texture_width;

vertex_point_complete_raw(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);

vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + TEXEL, ytex + texture_height - TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);

vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);

vertex_point_line_raw(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
vertex_point_line_raw(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);

return [buffer, wire];