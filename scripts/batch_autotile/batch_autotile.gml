/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityAutoTile

var buffer = argument0;
var wire = argument1;
var tile = argument2;
var TEXEL = 1 / TEXTURE_SIZE;

var xx = tile.xx * TILE_WIDTH;
var yy = tile.yy * TILE_HEIGHT;
var zz = tile.zz * TILE_WIDTH;

// todo correct normal calculation, and MAYBE normal smoothing, although
// i'm pretty sure that's going to be really expensive unless you bake it
// into the likely future map editing tool
var nx = 0;
var ny = 0;
var nz = 1;

var tile_horizontal_count = TEXTURE_SIZE / Stuff.tile_size;
var tile_vertical_count = TEXTURE_SIZE / Stuff.tile_size;

// texture coordinates go from 0...1, not 0...n, where n is the dimension
// of the image in pixels
var texture_width = 1 / tile_horizontal_count;
var texture_height = 1 / tile_vertical_count;

var xtex = tile.tile_x * texture_width;
var ytex = tile.tile_y * texture_width;

var color = tile.tile_color;
var alpha = tile.tile_alpha;

if (buffer) {
    vertex_point_complete(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
    vertex_point_complete(buffer, xx + TILE_WIDTH, yy, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + TEXEL, color, alpha);
    vertex_point_complete(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
    
    vertex_point_complete(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
    vertex_point_complete(buffer, xx, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + TEXEL, ytex + texture_height - TEXEL, color, alpha);
    vertex_point_complete(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
}

if (wire) {
    vertex_point_line(wire, xx, yy, zz, c_white, 1);
    vertex_point_line(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
    
    vertex_point_line(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
    vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
    
    vertex_point_line(wire, xx, yy, zz, c_white, 1);
    vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
    
    vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
    vertex_point_line(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
    
    vertex_point_line(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
    vertex_point_line(wire, xx, yy, zz, c_white, 1);
}

return [buffer, wire];