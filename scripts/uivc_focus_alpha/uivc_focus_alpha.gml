function uivc_focus_alpha(progress) {
    Settings.config.focus_alpha = progress.value;
    setting_set("Config", "focus-alpha", Settings.config.focus_alpha);
}