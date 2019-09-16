/// @param EntityMesh

var mesh = argument0;
var data = guid_get(mesh.mesh);

// You can't add anything other than triangles here, since this script is called
// in the middle of a trimesh.

var x1 = (mesh.xx + data.xmin) * TILE_WIDTH;
var y1 = (mesh.yy + data.ymin) * TILE_HEIGHT;
var z1 = (mesh.zz + data.zmin) * TILE_DEPTH;
var x2 = (mesh.xx + data.xmax) * TILE_WIDTH;
var y2 = (mesh.yy + data.ymax) * TILE_HEIGHT;
var z2 = (mesh.zz + data.zmax) * TILE_DEPTH;

// @todo other transformations?

c_shape_add_triangle(x1, y1, z1, x1, y2, z1, x2, y1, z1);
c_shape_add_triangle(x2, y1, z1, x1, y2, z1, x2, y2, z1);
c_shape_add_triangle(x1, y1, z2, x1, y2, z2, x2, y1, z2);
c_shape_add_triangle(x2, y1, z2, x1, y2, z2, x2, y2, z2);

c_shape_add_triangle(x1, y1, z1, x1, y1, z2, x2, y1, z1);
c_shape_add_triangle(x2, y1, z1, x1, y1, z2, x2, y1, z2);
c_shape_add_triangle(x1, y2, z1, x1, y2, z2, x2, y2, z1);
c_shape_add_triangle(x2, y2, z1, x1, y2, z2, x2, y2, z2);

c_shape_add_triangle(x1, y1, z1, x2, y1, z1, x1, y2, z1);
c_shape_add_triangle(x1, y2, z1, x2, y1, z1, x2, y2, z1);
c_shape_add_triangle(x1, y1, z2, x2, y1, z2, x1, y2, z2);
c_shape_add_triangle(x1, y2, z2, x2, y1, z2, x2, y2, z2);