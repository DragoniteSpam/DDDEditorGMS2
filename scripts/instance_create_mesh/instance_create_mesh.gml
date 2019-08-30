/// @param GUID

var mesh_data = guid_get(argument0);

with (instantiate(EntityMesh)) {
    name = mesh_data.name;
    mesh = mesh_data;
        
    entity_init_collision_mesh(id);
        
    return id;
}