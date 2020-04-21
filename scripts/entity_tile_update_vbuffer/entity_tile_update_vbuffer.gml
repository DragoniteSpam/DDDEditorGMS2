/// @param tile

var tile = argument0;

vertex_delete_buffer(tile.vbuffer);
tile.vbuffer = entity_tile_create_vbuffer(tile);