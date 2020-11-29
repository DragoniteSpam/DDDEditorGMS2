/// @param UIInput
function uivc_bezier_precision(argument0) {

    var input = argument0;

    Stuff.settings.config.bezier_precision = real(input.value);
    setting_set("Config", "bezier", Stuff.settings.config.bezier_precision);


}
