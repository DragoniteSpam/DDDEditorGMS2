/// @param EntityTile

var tile = argument0;

// You can't add anything other than triangles here, since this script is called
// in the middle of a trimesh. You can approximate with meshes, though.

var xx = tile.xx * TILE_WIDTH;
var yy = tile.yy * TILE_HEIGHT;
var zz = tile.zz * TILE_WIDTH;

c_transform_scaling(TILE_WIDTH, TILE_HEIGHT, TILE_DEPTH);
c_transform_position(xx, yy, zz);
c_shape_load_trimesh("data/basic/ctile.d3d");
c_transform_identity();