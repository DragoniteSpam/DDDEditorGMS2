/// @param buffer
/// @param Entity
/// @param version
function serialize_load_entity_mesh_autotile(argument0, argument1, argument2) {

	var buffer = argument0;
	var entity = argument1;
	var version = argument2;

	serialize_load_entity_mesh(buffer, entity, version);

	entity.terrain_id = buffer_read(buffer, buffer_u8);
	entity.terrain_type = buffer_read(buffer, buffer_u8);


}
