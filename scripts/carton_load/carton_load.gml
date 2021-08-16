/// @param filename
/// @param decompress

function carton_load(_filename, _decompress)
{
	var _buffer = buffer_load(_filename);

	if (_decompress)
	{
	    var _old_buffer = _buffer;
	    _buffer = buffer_decompress(_old_buffer);
	    buffer_delete(_old_buffer);
	}

	var _buffer_size = buffer_get_size(_buffer);

	var _header_carton = buffer_read(_buffer, buffer_string);
	if (_header_carton != "Carton @jujuadams") show_error("Carton:\nInvalid file format\n ", true);

	var _layout = [];
	var _carton = {
    	buffer : _buffer,
    	layout : _layout,
    }

	var _header_version = buffer_read(_buffer, buffer_string);
	switch(_header_version)
	{
	    case "1.0.0":
	    case "1.0.1":
	        while(buffer_tell(_buffer) < _buffer_size)
	        {
	            array_push(_layout, buffer_tell(_buffer));
	            var _metadata = buffer_read(_buffer, buffer_string); //Unusued in this script
                
                //Fix old buffer format sometimes being improperly formatted
                if (buffer_tell(_buffer) > _buffer_size - 4)
                {
                    show_debug_message("Carton: Warning! Prevented crash to due read outside the bounds of the buffer. Aborting");
                    break;
                }
                
    	        var _size = buffer_read(_buffer, buffer_u64);
    	        buffer_seek(_buffer, buffer_seek_relative, _size);
	        }
	    break;
        
	    case "1.0.2":
	        while(buffer_tell(_buffer) < _buffer_size)
	        {
	            array_push(_layout, buffer_tell(_buffer));
	            var _metadata = buffer_read(_buffer, buffer_string); //Unusued in this script
	            var _size = buffer_read(_buffer, buffer_u64);
	            buffer_seek(_buffer, buffer_seek_relative, _size);
	        }
	    break;
    
	    default:
	        show_error("Carton:\nUnsupported version (" + string(_header_version) + ")\n ", true);
	    break;
	}

	return _carton;
}