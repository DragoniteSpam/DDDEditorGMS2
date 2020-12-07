/// @param UIRadioOption
function uivc_radio_fill_type(argument0) {

    var radio = argument0;

    Settings.selection.fill_type = radio.value;
    setting_set("Selection", "fill-type", Settings.selection.fill_type);


}
