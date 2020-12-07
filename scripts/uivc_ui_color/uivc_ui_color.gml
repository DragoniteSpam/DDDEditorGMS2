function uivc_ui_color(picker) {
    Settings.config.color = picker.value;
    setting_set("Config", "color", Settings.config.color);
}