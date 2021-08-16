/// @param carton
/// @param index

function carton_get_buffer(_carton, _index)
{
	var _carton_buffer = _carton.buffer;
	var _carton_layout = _carton.layout;

	var _old_tell = buffer_tell(_carton_buffer);
	var _tell = _carton_layout[_index];
	if (_tell == undefined) show_error("Carton:\nIndex out of range (" + string(_index) + ")\n ", true);

	buffer_seek(_carton_buffer, buffer_seek_start, _tell);
	var _metadata = buffer_read(_carton_buffer, buffer_string); //Unused in this script
	var _size = buffer_read(_carton_buffer, buffer_u64);
	var _buffer = buffer_create(_size, buffer_grow, 1);
	buffer_copy(_carton_buffer, buffer_tell(_carton_buffer), _size, _buffer, 0);
	buffer_seek(_carton_buffer, buffer_seek_start, _old_tell);

	return _buffer;
}