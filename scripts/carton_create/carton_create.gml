function carton_create()
{
	var _buffer = buffer_create(CARTON_BUFFER_START_SIZE, buffer_grow, 1);
	buffer_write(_buffer, buffer_string, "Carton @jujuadams");
	buffer_write(_buffer, buffer_string, __CARTON_VERSION);

	return {
	    buffer : _buffer,
	    layout : [],
    };
}