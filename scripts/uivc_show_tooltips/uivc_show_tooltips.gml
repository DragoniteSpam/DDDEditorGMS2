/// @param UICheckbox
function uivc_show_tooltips(argument0) {

    var checkbox = argument0;

    Settings.config.tooltip = checkbox.value;
    setting_set("Config", "tooltip", Settings.config.tooltip);


}
