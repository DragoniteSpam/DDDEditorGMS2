/// @description void serialize_save_entity_pawn(buffer, EntityTile);
/// @param buffer
/// @param EntityTile

serialize_save_entity(argument0, argument1);

buffer_write(argument0, buffer_u8, argument1.map_direction);
// overworld sprite, etc
