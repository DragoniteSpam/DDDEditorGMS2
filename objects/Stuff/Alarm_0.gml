// we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

#region gather map settings
setting_set("Map", "x", map.x);
setting_set("Map", "y", map.y);
setting_set("Map", "z", map.z);
setting_set("Map", "xto", map.xto);
setting_set("Map", "yto", map.yto);
setting_set("Map", "zto", map.zto);
setting_set("Map", "xup", map.xup);
setting_set("Map", "yup", map.yup);
setting_set("Map", "zup", map.zup);
setting_set("Map", "fov", map.fov);
setting_set("Map", "pitch", map.pitch);
setting_set("Map", "direction", map.direction);
#endregion

#region gather event settings
setting_set("Event", "x", event.x);
setting_set("Event", "y", event.y);
setting_set("Event", "z", event.z);
setting_set("Event", "xto", event.xto);
setting_set("Event", "yto", event.yto);
setting_set("Event", "zto", event.zto);
setting_set("Event", "xup", event.xup);
setting_set("Event", "yup", event.yup);
setting_set("Event", "zup", event.zup);
setting_set("Event", "fov", event.fov);
setting_set("Event", "pitch", event.pitch);
setting_set("Event", "direction", event.direction);
#endregion

#region gather animation settings
setting_set("Animation", "x", animation.x);
setting_set("Animation", "y", animation.y);
setting_set("Animation", "z", animation.z);
setting_set("Animation", "xto", animation.xto);
setting_set("Animation", "yto", animation.yto);
setting_set("Animation", "zto", animation.zto);
setting_set("Animation", "xup", animation.xup);
setting_set("Animation", "yup", animation.yup);
setting_set("Animation", "zup", animation.zup);
setting_set("Animation", "fov", animation.fov);
setting_set("Animation", "pitch", animation.pitch);
setting_set("Animation", "direction", animation.direction);
#endregion

#region gather terrain settings
setting_set("Terrain", "x", terrain.x);
setting_set("Terrain", "y", terrain.y);
setting_set("Terrain", "z", terrain.z);
setting_set("Terrain", "xto", terrain.xto);
setting_set("Terrain", "yto", terrain.yto);
setting_set("Terrain", "zto", terrain.zto);
setting_set("Terrain", "xup", terrain.xup);
setting_set("Terrain", "yup", terrain.yup);
setting_set("Terrain", "zup", terrain.zup);
setting_set("Terrain", "fov", terrain.fov);
setting_set("Terrain", "pitch", terrain.pitch);
setting_set("Terrain", "direction", terrain.direction);
#endregion

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