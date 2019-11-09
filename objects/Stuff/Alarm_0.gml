// we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

var json = json_encode(settings);
var json_buffer = buffer_create(1000, buffer_grow, 1);
buffer_write(json_buffer, buffer_string, json);
buffer_save_ext(json_buffer, FILE_SETTINGS, 0, buffer_tell(json_buffer));
buffer_delete(json_buffer);

var buffer = buffer_create(1000, buffer_grow, 1);
for (var i = 0; i < ds_list_size(error_log_messages); i++) {
    buffer_write(buffer, buffer_string, error_log_messages[| i] + "\n");
}

buffer_save_ext(buffer, FILE_ERRORS, 0, buffer_tell(buffer));
buffer_delete(buffer);

// don't clear the error log otherwise it won't be there the next time the buffer is saved