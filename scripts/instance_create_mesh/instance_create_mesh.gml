function instance_create_mesh(mesh_data) {
    if (mesh_data) {
        with (instance_create_depth(0, 0, 0, EntityMesh)) {
            name = mesh_data.name;
            mesh = mesh_data.GUID;
            mesh_submesh = mesh_data.first_proto_guid;
            
            switch (mesh_data.type) {
                case MeshTypes.RAW:
                    break;
                case MeshTypes.SMF:
                    is_static = false;
                    batchable = false;
                    break;
            }
            
            entity_init_collision_mesh(id);
            
            return id;
        }
    }
    
    return noone;
}