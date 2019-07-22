/// @param UIThing
/// @param default

var location = get_temp_code_path(argument0);

if (file_exists(location)) {
    var buffer = buffer_load(location);
    if (buffer_get_size(buffer) > 0) {
        var text = buffer_read(buffer, buffer_text);
        buffer_delete(buffer);
        return text;
    }
}

return argument1;