/// @param fileHandle
function buffer_text_readln(_file_handle) {
	if (_file_handle[BUFFER_TEXT.PENDING])
	{
	    show_debug_message("buffer_text: Error! Async event for \"" + string(_file_handle[BUFFER_TEXT.FILENAME]) + "\" has not completed");
	    exit;
	}

	if (_file_handle[BUFFER_TEXT.FAILED])
	{
	    show_debug_message("buffer_text: Error! File I/O for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " failed");
	    exit;
	}

	if (_file_handle[BUFFER_TEXT.CLOSED])
	{
	    show_debug_message("buffer_text: Error! File handle for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " has been closed");
	    exit;
	}

	switch(_file_handle[BUFFER_TEXT.MODE])
	{
	    case BUFFER_TEXT_MODE.APPEND:
	        show_debug_message("buffer_text: Error! Cannot read from a file opened as APPEND");
	        exit;
	    break;
    
	    case BUFFER_TEXT_MODE.WRITE:
	        show_debug_message("buffer_text: Error! Cannot read from a file opened as WRITE");
	        exit;
	    break;
	}

	if (buffer_text_eof(_file_handle)) exit;

	var _buffer = _file_handle[BUFFER_TEXT.BUFFER];

	//Find the next newline
	var _value = 0;
	repeat(buffer_get_size(_buffer) - buffer_tell(_buffer))
	{
	    var _prev_value = _value;
	    var _value = buffer_read(_buffer, buffer_u8);
	    if ((_prev_value = 13) && (_value == 10)) break;
	}
}