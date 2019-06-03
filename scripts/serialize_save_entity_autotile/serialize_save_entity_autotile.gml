/// @description void serialize_save_entity_autotile(buffer, EntityAutoTile);
/// @param buffer
/// @param EntityAutoTile

serialize_save_entity_tile(argument0, argument1);

buffer_write(argument0, buffer_u8, argument1.autotile_id);
buffer_write(argument0, buffer_u8, argument1.segment_id);

// no bools
