/// @param EntityMesh
/// @param GUID

var entity = argument0;
var mesh_data = guid_get(argument1);

not_yet_implemented();

if (mesh_data) {
    entity.name = mesh_data.name;
    entity.entity = mesh_data;
    
    if (entity.cobject) {
        c_world_destroy_object(entity.cobject);
    }
    
    entity.cobject = c_object_create(mesh_data.cshape, 1, 1);
    
    map_transform_thing(entity);
	entity.modification = Modifications.UPDATE;
    ds_list_add(Camera.changes, entity);
    
    return true;
}

return false;