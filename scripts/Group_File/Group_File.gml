function file_get_contents(filename) {
	var buffer = buffer_load(filename);
	var contents = buffer_read(buffer, buffer_text);
	buffer_delete(buffer);
	return contents;
}