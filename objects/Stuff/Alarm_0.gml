// we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

for (var i = 0; i < ds_list_size(all_modes); i++) all_modes[| i].save();

var json_buffer = buffer_create(1000, buffer_grow, 1);
buffer_write(json_buffer, buffer_text, json_stringify(Settings));
buffer_save_ext(json_buffer, FILE_SETTINGS, 0, buffer_tell(json_buffer));
buffer_delete(json_buffer);