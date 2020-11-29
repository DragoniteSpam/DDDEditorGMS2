function uivc_ui_color(picker) {
    Stuff.settings.config.color = picker.value;
    setting_set("Config", "color", Stuff.settings.config.color);
}