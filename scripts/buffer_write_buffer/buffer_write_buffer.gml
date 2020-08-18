/// @param write-to
/// @param write-from
function buffer_write_buffer(argument0, argument1) {

	var destination = argument0;
	var source = argument1;

	var size = buffer_get_size(source);
	buffer_resize(destination, buffer_get_size(destination) + size);
	buffer_copy(source, 0, buffer_get_size(source), destination, buffer_tell(destination));
	buffer_seek(destination, buffer_seek_relative, size);


}
