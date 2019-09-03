/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity(buffer, entity, version);

if (version >= DataVersions.NEW_MESH_SYSTEM) {
    entity.mesh = buffer_read(buffer, buffer_datatype);
} else {
    // can't wait for this to be removed from the working version, honestly
    var mesh_name = buffer_read(buffer, buffer_string);
    for (var i = 0; i < ds_list_size(Stuff.all_meshes); i++) {
        if (Stuff.all_meshes[| i].name == mesh_name) {
            entity.mesh = Stuff.all_meshes[| i].GUID;
            break;
        }
    }
}

if (entity.mesh == 0) {
    // error handling of some sort, if needed
    not_yet_implemented();
}

entity_init_collision_mesh(entity);