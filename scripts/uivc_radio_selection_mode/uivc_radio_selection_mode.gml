/// @param UIRadioOption
function uivc_radio_selection_mode(argument0) {

    var radio = argument0;

    Stuff.settings.selection.mode = radio.value;
    setting_set("Selection", "mode", Stuff.settings.selection.mode);


}
