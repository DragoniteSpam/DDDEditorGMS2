/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity_mesh(buffer, entity, version);

entity.terrain_id = buffer_read(buffer, buffer_u8);
entity.terrain_type = buffer_read(buffer, buffer_u8);