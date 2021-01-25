function entity_mesh_set_mesh(entity, mesh_guid) {
    var mesh_data = guid_get(mesh_guid);
    not_yet_implemented_polite();
    return false;
    
    if (mesh_data) {
        entity.name = mesh_data.name;
        entity.entity = mesh_data;
        
        if (entity.cobject) {
            c_world_destroy_object(entity.cobject);
        }
        
        entity.cobject = c_object_create_cached(mesh_data.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
        entity.SetCollisionTransform();
        editor_map_mark_changed(entity);
        
        return true;
    }
    
    return false;
}