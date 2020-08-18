/// @param filename
function terrain_save(argument0) {

	var fn = argument0;

	// this is a DDD file but 

	var buffer = buffer_create(1000000, buffer_grow, 1);
	buffer_write(buffer, buffer_u8, $44);
	buffer_write(buffer, buffer_u8, $44);
	buffer_write(buffer, buffer_u8, $44);
	buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
	buffer_write(buffer, buffer_u8, SERIALIZE_DATA_AND_MAP);

	serialize_save_terrain(buffer);

	buffer_write(buffer, buffer_u32, SerializeThings.END_OF_FILE);

	var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
	buffer_save_ext(compressed, fn, 0, buffer_get_size(compressed));
	buffer_delete(compressed);
	buffer_delete(buffer);


}
