/// @param carton
/// @param metadata
/// @param buffer
/// @param [offset]
/// @param [size]

function carton_add()
{
	var _carton   = argument[0];
	var _metadata = argument[1];
	var _buffer   = argument[2];
	var _offset   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
	var _size     = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : buffer_get_size(_buffer);

	var _carton_buffer = _carton.buffer;
	var _carton_layout = _carton.layout;

	array_push(_carton_layout, buffer_tell(_carton_buffer));

	buffer_write(_carton_buffer, buffer_string, _metadata);
	buffer_write(_carton_buffer, buffer_u64, _size);

	if (buffer_get_size(_carton_buffer) < buffer_tell(_carton_buffer) + _size)
	{
	    buffer_resize(_carton_buffer, buffer_tell(_carton_buffer) + _size);
	}

	buffer_copy(_buffer, _offset, _size, _carton_buffer, buffer_tell(_carton_buffer));
	buffer_seek(_carton_buffer, buffer_seek_relative, _size);
}