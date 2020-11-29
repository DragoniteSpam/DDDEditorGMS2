function uivc_focus_alpha(progress) {
    Stuff.settings.config.focus_alpha = progress.value;
    setting_set("Config", "focus-alpha", Stuff.settings.config.focus_alpha);
}