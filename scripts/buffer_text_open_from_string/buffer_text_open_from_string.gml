/// @param string
function buffer_text_open_from_string(_string) {
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_poke(_buffer, 0, buffer_text, _string);

    var _array = array_create(BUFFER_TEXT.__SIZE);
    _array[BUFFER_TEXT.FILENAME] = undefined;
    _array[BUFFER_TEXT.BUFFER  ] = _buffer;
    _array[BUFFER_TEXT.MODE    ] = BUFFER_TEXT_MODE.FROM_STRING;
    _array[BUFFER_TEXT.PENDING ] = false;
    _array[BUFFER_TEXT.FAILED  ] = false;
    _array[BUFFER_TEXT.CLOSED  ] = false;
    _array[BUFFER_TEXT.CALLBACK] = undefined;

    return _array;
}