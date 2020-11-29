function uivc_camera_fly_rate(bar) {
    Stuff.settings.config.camera_fly_rate = normalize(progress.value, 0.5, 4, 0, 1);
    setting_set("Config", "camera-fly", Stuff.settings.config.camera_fly_rate);
}