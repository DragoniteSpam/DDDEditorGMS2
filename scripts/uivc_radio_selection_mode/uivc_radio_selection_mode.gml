/// @param UIRadioOption
function uivc_radio_selection_mode(argument0) {

    var radio = argument0;

    Stuff.setting_selection_mode = radio.value;
    setting_set("Selection", "mode", Stuff.setting_selection_mode);


}
