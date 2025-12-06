function buffer_text_async_event() {
    var _error  = async_load[? "error" ];
    var _status = async_load[? "status"];
    var _id     = async_load[? "id"    ];

    var _file_handle = global.__buffer_text_async_map[? _id];
    if (is_array(_file_handle))
    {
        _file_handle[@ BUFFER_TEXT.PENDING] = false;
    
        var _type = "???";
        switch(_file_handle[BUFFER_TEXT.MODE])
        {
            case BUFFER_TEXT_MODE.APPEND:      _type = "APPEND";      break;
            case BUFFER_TEXT_MODE.FROM_STRING: _type = "FROM_STRING"; break;
            case BUFFER_TEXT_MODE.READ:        _type = "READ";        break;
            case BUFFER_TEXT_MODE.WRITE:       _type = "WRITE";       break;
        }
    
        if ((_error < 0) || !_status)
        {
            show_debug_message("buffer_text: Error! File async " + _type + " failed for \"" + string(_file_handle[BUFFER_TEXT.FILENAME]) + "\"");
        
            var _buffer = _file_handle[@ BUFFER_TEXT.BUFFER];
            if (_buffer >= 0)
            {
                buffer_delete(_buffer);
                _file_handle[@ BUFFER_TEXT.BUFFER] = -1;
            }
        
            _file_handle[@ BUFFER_TEXT.FAILED] = true;
        }
    
        var _callback = _file_handle[@ BUFFER_TEXT.CALLBACK];
        if ((_callback != undefined) && script_exists(_callback)) script_execute(_callback, _file_handle);
    }
}