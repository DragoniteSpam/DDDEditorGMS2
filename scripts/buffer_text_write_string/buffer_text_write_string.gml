function buffer_text_write_string(_file_handle, _string) {
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
	    case BUFFER_TEXT_MODE.WRITE:
	        buffer_write(_file_handle[BUFFER_TEXT.BUFFER], buffer_text, _string);
	    break;
    
	    case BUFFER_TEXT_MODE.FROM_STRING:
	        show_debug_message("buffer_text: Error! Cannot write to a file opened as FROM_STRING");
	    break;
    
	    case BUFFER_TEXT_MODE.READ:
	        show_debug_message("buffer_text: Error! Cannot write to a file opened as READ");
	    break;
	}
}