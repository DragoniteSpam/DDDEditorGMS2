/// @param carton
/// @param index

function carton_get_metadata(_carton, _index)
{
	var _carton_buffer = _carton.buffer;
	var _carton_layout = _carton.layout;

	var _old_tell = buffer_tell(_carton_buffer);
	var _tell = _carton_layout[_index];
	if (_tell == undefined) show_error("Carton:\nIndex out of range (" + string(_index) + ")\n ", true);

	buffer_seek(_carton_buffer, buffer_seek_start, _tell);
	var _metadata = buffer_read(_carton_buffer, buffer_string);
	buffer_seek(_carton_buffer, buffer_seek_start, _old_tell);

	return _metadata;
}