/// @param buffer
/// @param EntityMesh

var buffer = argument0;
var entity = argument1;

serialize_save_entity(buffer, entity);

buffer_write(buffer, buffer_datatype, entity.mesh);

// no bools