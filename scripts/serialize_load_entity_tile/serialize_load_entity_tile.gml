/// @param buffer
/// @param EntityTile
/// @param version

var buffer = argument0;
var tile = argument1;
var version = argument2;

serialize_load_entity(buffer, tile, version);

tile.tile_x = buffer_read(buffer, buffer_u8);
tile.tile_y = buffer_read(buffer, buffer_u8);
tile.tile_color = buffer_read(buffer, buffer_u32);
tile.tile_alpha = buffer_read(buffer, buffer_u8)/255;

entity_init_collision_tile(tile);