/// @param UIInput
function uivc_bezier_precision(argument0) {

    var input = argument0;

    Settings.config.bezier_precision = real(input.value);
    setting_set("Config", "bezier", Settings.config.bezier_precision);


}
