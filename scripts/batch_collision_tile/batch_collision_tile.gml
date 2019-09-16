/// @param EntityTile

var tile = argument0;

// You can't add anything other than triangles here, since this script is called
// in the middle of a trimesh.

var x1 = tile.xx * TILE_WIDTH;
var y1 = tile.yy * TILE_HEIGHT;
var z = tile.zz * TILE_WIDTH;
var x2 = (tile.xx + 1) * TILE_WIDTH;
var y2 = (tile.yy + 1) * TILE_HEIGHT;

// @todo rotated tiles?
c_shape_add_triangle(x1, y1, z, x1, y2, z, x2, y1, z);
c_shape_add_triangle(x2, y1, z, x1, y2, z, x2, y2, z);