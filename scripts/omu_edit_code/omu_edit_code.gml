/// @param UIInputCode

var code = argument0;

var location = code.is_code ? get_temp_code_path(code) : get_temp_text_path(code);

var buffer = buffer_create(1, buffer_grow, 1);
buffer_write(buffer, buffer_text, code.value);
buffer_save_ext(buffer, location, 0, buffer_tell(buffer));
buffer_delete(buffer);

code.editor_handle = ds_stuff_open_local(location);