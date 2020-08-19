/// @param UIColorPicker
function uivc_ui_color(argument0) {

    var picker = argument0;

    Stuff.setting_color = picker.value;
    setting_set("Config", "color", Stuff.setting_color);


}
