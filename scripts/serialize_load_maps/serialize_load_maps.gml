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
	
	ds_list_add(Stuff.all_maps, map);
}

// this needs to be read after Game Global Meta, since that stores the
// starting map - this may be changed to a system that makes sense later but
// for now i dont want to deal with it
if (version < DataVersions.MAPS_NUKED) {
	if (Stuff.active_map) {
		instance_activate_object(Stuff.active_map.contents);
		instance_destroy(Stuff.active_map.contents);
	}
}
if (version >= DataVersions.MAPS_NUKED) {
	Stuff.active_map = guid_get(Stuff.game_map_starting);
} else {
	Stuff.active_map = internal_name_get(Stuff.game_map_starting);
	Stuff.game_map_starting = Stuff.active_map.GUID;
}

serialize_load_current_map(Stuff.active_map, version);

uivc_select_autotile_refresh();