/// @param carton
/// @param filename
/// @param compress

function carton_save(_carton, _filename, _compress)
{
	var _buffer = _carton.buffer;

	if (_compress)
	{
	    var _compressed_buffer = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	    buffer_save(_compressed_buffer, _filename);
	    buffer_delete(_compressed_buffer);
	}
	else
	{
	    buffer_save_ext(_buffer, _filename, 0, buffer_tell(_buffer));
	}
}