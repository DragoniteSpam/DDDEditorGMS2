/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_maps = buffer_read(buffer, buffer_u16);
show_message(n_maps);

repeat (n_maps) {
	var name = buffer_read(buffer, buffer_string);
	var size = buffer_read(buffer, buffer_u32);
	var buffer = buffer_read_buffer(buffer, size);
	// add the last added map to Stuff.all_maps
}

uivc_select_autotile_refresh();