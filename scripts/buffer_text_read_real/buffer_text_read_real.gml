/// @param fileHandle
function buffer_text_read_real(_file_handle) {
	if (_file_handle[BUFFER_TEXT.PENDING])
	{
	    show_debug_message("buffer_text: Error! Async event for \"" + string(_file_handle[BUFFER_TEXT.FILENAME]) + "\" has not completed");
	    return 0;
	}

	if (_file_handle[BUFFER_TEXT.FAILED])
	{
	    show_debug_message("buffer_text: Error! File I/O for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " failed");
	    return 0;
	}

	if (_file_handle[BUFFER_TEXT.CLOSED])
	{
	    show_debug_message("buffer_text: Error! File handle for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " has been closed");
	    return 0;
	}

	switch(_file_handle[BUFFER_TEXT.MODE])
	{
	    case BUFFER_TEXT_MODE.APPEND:
	        show_debug_message("buffer_text: Error! Cannot read from a file opened as APPEND");
	        return 0;
	    break;
    
	    case BUFFER_TEXT_MODE.WRITE:
	        show_debug_message("buffer_text: Error! Cannot read from a file opened as WRITE");
	        return 0;
	    break;
	}

	if (buffer_text_eof(_file_handle)) return 0;



	var _buffer = _file_handle[BUFFER_TEXT.BUFFER];

	//Find where the next number begins
	var _found = false;
	repeat(buffer_get_size(_buffer) - buffer_tell(_buffer))
	{
	    var _value = buffer_read(_buffer, buffer_u8);
	    if (_value == 45) || ((_value >= 48) && (_value <= 57))
	    {
	        _found = true;
	        break;
	    }
	    else if (_value > 32)
	    {
	        break;
	    }
	}

	if (!_found) return 0;

	//Take a step back
	var _tell = buffer_tell(_buffer) - 1;



	//Find where the number ends
	var _found = false;
	repeat(buffer_get_size(_buffer) - _tell)
	{
	    var _value = buffer_read(_buffer, buffer_u8);
	    if (_value <= 32)
	    {
	        _found = true;
	        buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0);
	        buffer_seek(_buffer, buffer_seek_start, _tell);
	        break;
	    }
	}

	if (!_found) return 0;



	//Read the digits in as a string
	var _string = buffer_read(_buffer, buffer_string);

	//Replace the null byte with the value we read
	buffer_seek(_buffer, buffer_seek_relative, -1);
	buffer_poke(_buffer, buffer_tell(_buffer), buffer_u8, _value);

	//Return our value as a real
	return real(_string);
}