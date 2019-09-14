/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_maps = buffer_read(buffer, buffer_u16);

repeat (n_maps) {
	var map = instance_create_depth(0, 0, 0, DataMapContainer);
	serialize_load_generic(buffer, map, version);
	
	var size = buffer_read(buffer, buffer_u32);
	map.data_buffer = buffer_read_buffer(buffer, size);
}

Stuff.active_map = guid_get(Stuff.game_starting_map);

serialize_load_current_map(Stuff.active_map, version);

uivc_select_autotile_refresh();