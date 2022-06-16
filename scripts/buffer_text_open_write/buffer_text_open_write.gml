/// @param filename
function buffer_text_open_write(_file_handle) {
	var _buffer = buffer_create(BUFFER_TEXT_DEFAULT_SIZE, buffer_grow, 1);

	var _array = array_create(BUFFER_TEXT.__SIZE);
	_array[BUFFER_TEXT.FILENAME] = _filename;
	_array[BUFFER_TEXT.BUFFER  ] = _buffer;
	_array[BUFFER_TEXT.MODE    ] = BUFFER_TEXT_MODE.WRITE;
	_array[BUFFER_TEXT.PENDING ] = false;
	_array[BUFFER_TEXT.FAILED  ] = false;
	_array[BUFFER_TEXT.CLOSED  ] = false;
	_array[BUFFER_TEXT.CALLBACK] = undefined;

	return _array;
}