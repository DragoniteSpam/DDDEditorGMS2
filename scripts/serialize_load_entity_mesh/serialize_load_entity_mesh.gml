/// @description  void serialize_load_entity_mesh(buffer, Entity, version);
/// @param buffer
/// @param  Entity
/// @param  version

serialize_load_entity(argument0, argument1, argument2);

argument1.mesh_id=buffer_read(argument0, buffer_string);
argument1.mesh_data=Stuff.vra_data[? argument1.mesh_id];

entity_init_collision_mesh(argument1);
