/// @param instance-id

var mesh_data = argument0;

if (mesh_data) {
    with (instantiate(EntityMesh)) {
        name = mesh_data.name;
        mesh = mesh_data.GUID;
        
        entity_init_collision_mesh(id);
        
        return id;
    }
}

return noone;