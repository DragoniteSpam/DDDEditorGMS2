function buffer_text_writeln(_file_handle) {
	//As tempting as it is, don't change this newline string as it'll break compatibility with native GM functions
	buffer_text_write_string(_file_handle, "\r\n");
}