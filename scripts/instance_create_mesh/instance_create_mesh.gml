/// @param MeshName

if (ds_map_exists(Stuff.vra_data, argument[0])) {
    with (instantiate(EntityMesh)) {
        name = argument[0];
        mesh_id = argument[0];
        mesh_data = Stuff.vra_data[? argument[0]];
        
        entity_init_collision_mesh(id);
        
        return id;
    }
}

return noone;