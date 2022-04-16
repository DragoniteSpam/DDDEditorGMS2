// we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

for (var i = 0; i < ds_list_size(all_modes); i++) {
    if (is_struct(all_modes[| i])) {
        all_modes[| i].Save();
    } else {
        all_modes[| i].save();
    }
}

buffer_write_file(json_stringify(Settings), FILE_SETTINGS);
