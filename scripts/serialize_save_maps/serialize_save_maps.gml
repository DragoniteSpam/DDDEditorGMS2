/// @param buffer
function serialize_save_maps(argument0) {

	var buffer = argument0;

	buffer_delete(Stuff.map.active_map.data_buffer);
	Stuff.map.active_map.version = DataVersions._CURRENT - 1;
	Stuff.map.active_map.data_buffer = serialize_save_current_map();

	buffer_write(buffer, buffer_u32, SerializeThings.MAPS);
	var addr_next = buffer_tell(buffer);
	buffer_write(buffer, buffer_u64, 0);

	var n_maps = ds_list_size(Stuff.all_maps);
	buffer_write(buffer, buffer_u16, n_maps);

	for (var i = 0; i < n_maps; i++) {
	    var map = Stuff.all_maps[| i];
	    serialize_save_generic(buffer, map);
	    buffer_write(buffer, buffer_u32, map.version);
	    buffer_write(buffer, buffer_u32, buffer_get_size(map.data_buffer));
	    buffer_write_buffer(buffer, map.data_buffer);
	}

	buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

	return buffer_tell(buffer);


}
