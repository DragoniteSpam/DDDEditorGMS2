/// @param EntityMesh
/// @param name

var mesh = argument0;
var mesh_data = guid_get(mesh.mesh);
var name = argument1;

// everything below this line is gross and needs to go probably
stack_trace();

if (ds_map_exists(Stuff.vra_data, argument[1])) {
    argument[0].name = argument[1];
    argument[0].mesh_id = argument[1];
    argument[0].mesh_data = Stuff.vra_data[? argument[1]];
    
    if (argument[0].cobject) {
        c_world_destroy_object(argument[0].cobject);
    }
    
    cobject = c_object_create(argument[0].mesh_data[@ MeshArrayData.CDATA], 1, 1);
    
    map_transform_thing(argument[0]);
	argument[0].modification = Modifications.UPDATE;
    ds_list_add(Camera.changes, argument[0]);
    
    return true;
}

return false;