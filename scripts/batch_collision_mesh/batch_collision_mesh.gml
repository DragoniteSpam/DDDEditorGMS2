/// @param EntityMesh

var mesh = argument0;
var data = guid_get(mesh.mesh);

// You can't add anything other than triangles here, since this script is called
// in the middle of a trimesh. You can approximate with meshes, though.

var xx = (mesh.xx + data.xmin) * TILE_WIDTH;
var yy = (mesh.yy + data.ymin) * TILE_HEIGHT;
var zz = (mesh.zz + data.zmin) * TILE_DEPTH;

var xscale = (data.xmax - data.xmin) * TILE_WIDTH;
var yscale = (data.ymax - data.ymin) * TILE_HEIGHT;
var zscale = (data.zmax - data.zmin) * TILE_DEPTH;

c_transform_scaling(xscale, yscale, zscale);
c_transform_position(xx, yy, zz);
c_shape_load_trimesh("data/basic/ccube.d3d");
c_transform_identity();