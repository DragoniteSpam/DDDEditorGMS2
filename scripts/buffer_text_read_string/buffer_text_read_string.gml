/// @param fileHandle
function buffer_text_read_string(_file_handle) {
    if (_file_handle[BUFFER_TEXT.PENDING])
    {
        show_debug_message("buffer_text: Error! Async event for \"" + string(_file_handle[BUFFER_TEXT.FILENAME]) + "\" has not completed");
        return "";
    }

    if (_file_handle[BUFFER_TEXT.FAILED])
    {
        show_debug_message("buffer_text: Error! File I/O for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " failed");
        return "";
    }

    if (_file_handle[BUFFER_TEXT.CLOSED])
    {
        show_debug_message("buffer_text: Error! File handle for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " has been closed");
        return "";
    }

    switch(_file_handle[BUFFER_TEXT.MODE])
    {
        case BUFFER_TEXT_MODE.APPEND:
            show_debug_message("buffer_text: Error! Cannot read from a file opened as APPEND");
            return "";
        break;
    
        case BUFFER_TEXT_MODE.WRITE:
            show_debug_message("buffer_text: Error! Cannot read from a file opened as WRITE");
            return "";
        break;
    }

    if (buffer_text_eof(_file_handle)) return "";

    var _buffer = _file_handle[BUFFER_TEXT.BUFFER];
    var _tell = buffer_tell(_buffer);

    //Find where the string ends
    var _found = false;
    repeat(buffer_get_size(_buffer) - _tell)
    {
        var _value = buffer_read(_buffer, buffer_u8);
        if (_value < 32)
        {
            _found = true;
            buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0);
            buffer_seek(_buffer, buffer_seek_start, _tell);
            break;
        }
    }

    if (!_found) return "";

    //Read the string
    var _string = buffer_read(_buffer, buffer_string);

    //Replace the null byte with the value we read
    buffer_seek(_buffer, buffer_seek_relative, -1);
    buffer_poke(_buffer, buffer_tell(_buffer), buffer_u8, _value);

    //Return the string
    return _string;
}