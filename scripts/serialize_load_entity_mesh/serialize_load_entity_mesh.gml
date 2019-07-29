/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity(buffer, entity, version);

entity.mesh_id = buffer_read(buffer, buffer_string);
entity.mesh_data = Stuff.vra_data[? entity.mesh_id];

entity_init_collision_mesh(entity);