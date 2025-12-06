/// @param filename
/// @param [callback]
function buffer_text_open_append(_filename, _callback = undefined) {
    var _array = array_create(BUFFER_TEXT.__SIZE);
    _array[BUFFER_TEXT.FILENAME] = _filename;
    _array[BUFFER_TEXT.BUFFER  ] = -1;
    _array[BUFFER_TEXT.MODE    ] = BUFFER_TEXT_MODE.APPEND;
    _array[BUFFER_TEXT.PENDING ] = global.__buffer_text_async;
    _array[BUFFER_TEXT.FAILED  ] = false;
    _array[BUFFER_TEXT.CLOSED  ] = false;
    _array[BUFFER_TEXT.CALLBACK] = _callback;

    if (global.__buffer_text_async)
    {
        var _buffer = buffer_create(BUFFER_TEXT_DEFAULT_SIZE, buffer_grow, 1);
        var _async_handle = buffer_load_async(_buffer, _filename, 0, BUFFER_TEXT_MAX_SIZE);
        global.__buffer_text_async_map[? _async_handle] = _array;
    }
    else
    {
        if (file_exists(_filename))
        {
                var _source_buffer = buffer_load(_filename);
                //Make our working buffer size the size of the source since that's what GM does when growing a buffer
                var _buffer = buffer_create(2*buffer_get_size(_source_buffer), buffer_grow, 1);
                buffer_copy(_source_buffer, 0, buffer_get_size(_source_buffer), _buffer, 0);
                buffer_delete(_source_buffer);
        }
        else
        {
            var _buffer = buffer_create(BUFFER_TEXT_DEFAULT_SIZE, buffer_grow, 1);
        }
    }

    _array[@ BUFFER_TEXT.BUFFER] = _buffer;

    if (!global.__buffer_text_async)
    {
        _callback = _array[@ BUFFER_TEXT.CALLBACK];
        if ((_callback != undefined) && script_exists(_callback)) script_execute(_callback, _array);
    }

    return _array;
}