/// @param DataMapContainer
/// @param version

var map = argument0;
var version = argument1;
var buffer = map.data_buffer;

if (Stuff.active_map) {
	buffer_delete(Stuff.active_map.data_buffer);
	Stuff.active_map.data_buffer = serialize_save_current_map();
	if (Stuff.active_map.contents) instance_destroy(Stuff.active_map.contents);
}

Stuff.active_map = map;

map.contents = instance_create_depth(0, 0, 0, MapContents);
instance_deactivate_object(map.contents);

if (buffer_md5(buffer, 0, buffer_get_size(buffer)) != EMPTY_BUFFER_MD5) {
	buffer_seek(buffer, buffer_seek_start, 0);

	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_meta(buffer, version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_batch(buffer, version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_dynamic(buffer, version, map);
} // else the map has not been initialized yet and it just uses its default values

// @todo this shouldn't be here, but in the actual UI code
uivc_select_autotile_refresh();
// this also
var list = Camera.ui.t_maps.el_map_list;
for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
	if (Stuff.all_maps[| i] == Stuff.active_map) {
		ds_map_add(list.selected_entries, i, true);
		script_execute(list.onvaluechange, list);
		break;
	}
}