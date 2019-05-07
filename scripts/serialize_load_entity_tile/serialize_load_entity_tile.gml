/// @description  void serialize_load_entity_tile(buffer, Entity, version);
/// @param buffer
/// @param  Entity
/// @param  version

serialize_load_entity(argument0, argument1, argument2);

argument1.tile_x=buffer_read(argument0, buffer_u8);
argument1.tile_y=buffer_read(argument0, buffer_u8);
argument1.tile_color=buffer_read(argument0, buffer_u32);
argument1.tile_alpha=buffer_read(argument0, buffer_u8)/255;

entity_init_collision_tile(argument1);
