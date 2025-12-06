/// @param filename
/// @param [callback]
function buffer_text_open_read(_filename, _callback = undefined) {
    var _array = array_create(BUFFER_TEXT.__SIZE);
    _array[BUFFER_TEXT.FILENAME] = _filename;
    _array[BUFFER_TEXT.BUFFER  ] = -1;
    _array[BUFFER_TEXT.MODE    ] = BUFFER_TEXT_MODE.READ;
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
        var _buffer = buffer_load(_filename);
    }

    _array[@ BUFFER_TEXT.BUFFER] = _buffer;

    if (!global.__buffer_text_async)
    {
        _callback = _array[@ BUFFER_TEXT.CALLBACK];
        if ((_callback != undefined) && script_exists(_callback)) script_execute(_callback, _array);
    }

    return _array;
}