/// @param buffer
/// @param EntityTile
function serialize_save_entity_tile(argument0, argument1) {

	// just a fyi, the "static" variable doesn't do anything for tiles because
	// they're (currently) not allowed to move at all

	var buffer = argument0;
	var entity = argument1;

	serialize_save_entity(buffer, entity);

	buffer_write(buffer, buffer_u8, entity.tile_x);
	buffer_write(buffer, buffer_u8, entity.tile_y);
	buffer_write(buffer, buffer_u32, entity.tile_color);
	buffer_write(buffer, buffer_u8, floor(entity.tile_alpha * 255));

	// no bools


}
