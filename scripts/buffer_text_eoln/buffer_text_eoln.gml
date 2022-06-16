/// @param fileHandle
function buffer_text_eoln(_file_handle) {
	if (buffer_text_eof(_file_handle)) return true;

	if (_file_handle[BUFFER_TEXT.PENDING]) return true;
	if (_file_handle[BUFFER_TEXT.FAILED]) return true;
	if (_file_handle[BUFFER_TEXT.CLOSED]) return true;

	var _buffer = _file_handle[BUFFER_TEXT.BUFFER];

	var _tell = buffer_tell(_buffer);
	var _string = buffer_read(_buffer, buffer_string);
	buffer_seek(_buffer, buffer_seek_start, _tell);

	return (_string == "\r\n");
}