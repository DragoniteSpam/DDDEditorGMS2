/// @param UICheckbox
function uivc_settings_alt_middle(argument0) {

    var checkbox = argument0;

    Settings.config.alternate_middle = checkbox.value;
    setting_set("Config", "alt-mid", Settings.config.alternate_middle);


}
