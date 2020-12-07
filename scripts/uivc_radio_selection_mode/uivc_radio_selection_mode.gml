/// @param UIRadioOption
function uivc_radio_selection_mode(argument0) {

    var radio = argument0;

    Settings.selection.mode = radio.value;
    setting_set("Selection", "mode", Settings.selection.mode);


}
