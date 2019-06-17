/// @param UIThing

var location = get_temp_code_path(argument0);

if (file_exists(location)) {
    var buffer = buffer_load(location);
    if (buffer_get_size(buffer) > 0) {
        argument0.value = buffer_read(buffer, buffer_text);
        buffer_delete(buffer);
    }
}