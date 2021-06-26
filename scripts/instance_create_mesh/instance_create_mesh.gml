function instance_create_mesh(mesh_data) {
    if (mesh_data) {
        var mesh = new EntityMesh();
        mesh.name = mesh_data.name;
        mesh.mesh = mesh_data.GUID;
        mesh.mesh_submesh = mesh_data.first_proto_guid;
        
        switch (mesh_data.type) {
            case MeshTypes.RAW:
                break;
            case MeshTypes.SMF:
                mesh.is_static = false;
                mesh.batchable = false;
                break;
        }
        
        entity_init_collision_mesh(mesh);
        
        return mesh;
    }
    
    return undefined;
}