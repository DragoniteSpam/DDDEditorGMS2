/// @param EntityMesh
/// @param GUID

var entity = argument0;
var mesh_data = guid_get(argument1);

not_yet_implemented_polite();

return false;

if (mesh_data) {
    entity.name = mesh_data.name;
    entity.entity = mesh_data;
    
    if (entity.cobject) {
        c_world_destroy_object(entity.cobject);
    }
    
    entity.cobject = c_object_create_cached(mesh_data.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
    
    map_transform_thing(entity);
    editor_map_mark_changed(entity);
    
    return true;
}

return false;