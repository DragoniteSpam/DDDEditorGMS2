function uivc_camera_fly_rate(bar) {
    Settings.config.camera_fly_rate = normalize(progress.value, 0.5, 4, 0, 1);
    setting_set("Config", "camera-fly", Settings.config.camera_fly_rate);
}