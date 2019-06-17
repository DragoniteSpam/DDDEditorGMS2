/// @param UIThing

var location = get_temp_code_path(argument0);

var buffer = buffer_create(1, buffer_grow, 1);
buffer_write(buffer, buffer_text, argument0.value);
buffer_save_ext(buffer, location, 0, buffer_tell(buffer));
buffer_delete(buffer);

argument0.editor_handle = ds_stuff_open_local(location);