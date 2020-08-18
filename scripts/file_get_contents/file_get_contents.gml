/// @param filename
function file_get_contents(argument0) {

	var buffer = buffer_load(argument0);
	var contents = buffer_read(buffer, buffer_text);
	buffer_delete(buffer);
	return contents;


}
