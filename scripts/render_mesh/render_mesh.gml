/// @param EntityMesh
function render_mesh(argument0) {

    var entity = argument0;
    var mesh = guid_get(entity.mesh);

    if (mesh && entity_mesh_get_vbuffer(entity)) {
        switch (mesh.type) {
            case MeshTypes.RAW: render_mesh_raw(entity); break;
            case MeshTypes.SMF: render_mesh_smf(entity); break;
        }
    } else {
        render_mesh_missing(entity);
    }


}
