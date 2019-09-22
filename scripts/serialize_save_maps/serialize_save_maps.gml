/// @param buffer

var buffer = argument0;

buffer_delete(Stuff.active_map.data_buffer);
Stuff.active_map.data_buffer = serialize_save_current_map();

buffer_write(buffer, buffer_datatype, SerializeThings.MAPS);

var n_maps = ds_list_size(Stuff.all_maps);
buffer_write(buffer, buffer_u16, n_maps);

for (var i = 0; i < n_maps; i++) {
	var map = Stuff.all_maps[| i];
	serialize_save_generic(buffer, map);
	buffer_write(buffer, buffer_u32, buffer_get_size(map.data_buffer));
	buffer_write_buffer(buffer, map.data_buffer);
}