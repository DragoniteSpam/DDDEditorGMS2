/// @param UIThing

var location = PATH_TEMP_CODE + string(argument0.id) + get_code_extension();

var f = file_text_open_write(location);
file_text_write_string(f, argument0.value);
file_text_close(f);

argument0.editor_handle = ds_stuff_open_local(location);