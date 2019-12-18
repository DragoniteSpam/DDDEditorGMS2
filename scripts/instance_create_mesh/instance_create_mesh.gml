/// @param mesh-data

var mesh_data = argument0;

if (mesh_data) {
    with (instance_create_depth(0, 0, 0, EntityMesh)) {
        name = mesh_data.name;
        mesh = mesh_data.GUID;
        
        switch (mesh_data.type) {
            case MeshTypes.RAW:
                break;
            case MeshTypes.SMF:
                static = false;
                batchable = false;
                break;
        }
        
        entity_init_collision_mesh(id);
        
        return id;
    }
}

return noone;