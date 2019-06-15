/// @param UIThing

var location = PATH_TEMP_CODE + string(argument0.id) + get_code_extension();

if (file_exists(location)) {
    var buffer = buffer_load(location);
    if (buffer_get_size(buffer) > 0) {
        argument0.value = buffer_read(buffer, buffer_text);
        buffer_delete(buffer);
    }
}