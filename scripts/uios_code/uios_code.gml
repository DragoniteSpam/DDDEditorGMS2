/// @param UIThing

var location = PATH_TEMP_CODE + string(argument0.id) + get_code_extension();

var buffer = buffer_load(location);
argument0.value = buffer_read(buffer, buffer_text);
buffer_delete(buffer);
file_delete(location);