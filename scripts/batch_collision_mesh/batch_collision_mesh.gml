/// @param shape
/// @param EntityMesh

var shape = argument0;
var mesh = argument1;
var data = guid_get(mesh.mesh);

var xx = (mesh.xx + data.xmin + 0.5) * TILE_WIDTH;
var yy = (mesh.yy + data.ymin + 0.5) * TILE_HEIGHT;
var zz = (mesh.zz + data.zmin + 0.5) * TILE_DEPTH;

var xscale = (data.xmax - data.xmin) * TILE_WIDTH / 2;
var yscale = (data.ymax - data.ymin) * TILE_HEIGHT / 2;
var zscale = (data.zmax - data.zmin) * TILE_DEPTH / 2;

c_transform_position(xx, yy, zz);
c_shape_add_box(shape, xscale, yscale, zscale);
c_transform_identity();