/// @param UIInputCode
/// @param default
function uios_code_text(argument0, argument1) {

    var code = argument0;
    var def_value = argument1;

    var location = code.is_code ? get_temp_code_path(code) : get_temp_text_path(code);

    if (file_exists(location)) {
        var buffer = buffer_load(location);
        var text = (buffer_get_size(buffer) > 0) ? buffer_read(buffer, buffer_text) : "";
        buffer_delete(buffer);
        return text;
    }

    return def_value;


}
