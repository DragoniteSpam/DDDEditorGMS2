/// @param shape
/// @param EntityTile

var shape = argument0;
var tile = argument1;

var xx = tile.xx * TILE_WIDTH;
var yy = tile.yy * TILE_HEIGHT;
var zz = tile.zz * TILE_WIDTH;

c_transform_position(xx + TILE_WIDTH / 2, yy + TILE_HEIGHT / 2, zz);
c_shape_add_box(shape, TILE_WIDTH / 2, TILE_HEIGHT / 2, 0);
c_transform_identity();