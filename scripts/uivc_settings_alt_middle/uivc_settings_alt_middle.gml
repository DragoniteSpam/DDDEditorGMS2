/// @param UICheckbox
function uivc_settings_alt_middle(argument0) {

    var checkbox = argument0;

    Stuff.setting_alternate_middle = checkbox.value;
    setting_set("Config", "alt-mid", Stuff.setting_alternate_middle);


}
