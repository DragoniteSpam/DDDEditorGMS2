/// @param buffer
/// @param EntityPawn

var buffer = argument0;
var tile = argument1;

serialize_save_entity(buffer, tile);

buffer_write(buffer, buffer_u8, tile.map_direction);
// overworld sprite, etc?