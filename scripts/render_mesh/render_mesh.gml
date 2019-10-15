/// @param EntityMesh

var entity = argument0;
var mesh = guid_get(entity.mesh);

switch (mesh.type) {
    case MeshTypes.RAW: render_mesh_raw(entity); break;
    case MeshTypes.SMF: render_mesh_smf(entity); break;
}