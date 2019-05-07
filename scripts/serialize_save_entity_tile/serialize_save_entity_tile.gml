/// @description  void serialize_save_entity_tile(buffer, EntityTile);
/// @param buffer
/// @param  EntityTile

// just a fyi, the "static" variable doesn't do anything for tiles because
// they're (currently) not allowed to move at all

serialize_save_entity(argument0, argument1);

buffer_write(argument0, buffer_u8, argument1.tile_x);
buffer_write(argument0, buffer_u8, argument1.tile_y);
buffer_write(argument0, buffer_u32, argument1.tile_color);
buffer_write(argument0, buffer_u8, floor(argument1.tile_alpha*255));

// no bools
