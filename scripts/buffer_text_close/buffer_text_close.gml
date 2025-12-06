/// @param fileHandle
/// @param [callback]
function buffer_text_close(_file_handle, _callback = undefined) {
    if (_file_handle[BUFFER_TEXT.PENDING])
    {
        show_debug_message("buffer_text: Error! Async event for \"" + string(_filename) + "\" has not completed");
        exit;
    }

    if (_file_handle[BUFFER_TEXT.FAILED])
    {
        show_debug_message("buffer_text: Error! File I/O for " + string(_file_handle[BUFFER_TEXT.FILENAME]) + " failed");
        exit;
    }

    if (_file_handle[BUFFER_TEXT.CLOSED])
    {
        show_debug_message("buffer_text: Error! File handle for \"" + string(_filename) + "\" has already been closed");
        exit;
    }

    var _filename = _file_handle[BUFFER_TEXT.FILENAME];
    var _buffer   = _file_handle[BUFFER_TEXT.BUFFER  ];
    var _mode     = _file_handle[BUFFER_TEXT.MODE    ];
    _file_handle[@ BUFFER_TEXT.CALLBACK] = _callback;

    switch(_mode)
    {
        case BUFFER_TEXT_MODE.APPEND:
        case BUFFER_TEXT_MODE.WRITE:
            if (global.__buffer_text_async)
            {
                _file_handle[BUFFER_TEXT.PENDING] = true;
            
                var _async_handle = buffer_save_async(_buffer, _filename, 0, buffer_tell(_buffer));
                global.__buffer_text_async_map[? _async_handle] = _file_handle;
            }
            else
            {
                buffer_save(_buffer, _filename);
            }
        break;
    
        case BUFFER_TEXT_MODE.FROM_STRING:
        case BUFFER_TEXT_MODE.READ:
        break;
    }

    buffer_delete(_buffer);
    _file_handle[@ BUFFER_TEXT.BUFFER] = -1;
    _file_handle[@ BUFFER_TEXT.CLOSED] = true;

    if (!global.__buffer_text_async)
    {
        _callback = _file_handle[@ BUFFER_TEXT.CALLBACK];
        if ((_callback != undefined) && script_exists(_callback)) script_execute(_callback, _file_handle);
    }
}