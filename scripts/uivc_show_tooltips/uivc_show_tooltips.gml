/// @param UICheckbox
function uivc_show_tooltips(argument0) {

    var checkbox = argument0;

    Stuff.settings.config.tooltip = checkbox.value;
    setting_set("Config", "tooltip", Stuff.settings.config.tooltip);


}
