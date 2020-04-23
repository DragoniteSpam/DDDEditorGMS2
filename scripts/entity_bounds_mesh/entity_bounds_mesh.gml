/// @param EntityMesh

var mesh = argument0;
var mesh_data = guid_get(mesh.mesh);

return [entity.xx + mesh_data.xmin, entity.yy + mesh_data.ymin, entity.zz + mesh_data.zmin, entity.xx + mesh_data.xmax, entity.yy + mesh_data.ymax, entity.zz + mesh_data.zmax];