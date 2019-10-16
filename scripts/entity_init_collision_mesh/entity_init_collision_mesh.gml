/// @param EntityMesh

var mesh = argument0;
var mesh_data = guid_get(mesh.mesh);

if (mesh_data.cshape) {
    mesh.cobject = c_object_create(mesh_data.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
}