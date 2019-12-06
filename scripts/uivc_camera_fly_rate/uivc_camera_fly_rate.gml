/// @param UIProgressBar

var progress = argument0;

Stuff.setting_camera_fly_rate = normalize_correct(progress.value, 0.5, 4, 0, 1);
setting_set("Config", "camera-fly", Stuff.setting_camera_fly_rate);