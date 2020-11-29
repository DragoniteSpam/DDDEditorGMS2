/// @param UIRadioOption
function uivc_radio_fill_type(argument0) {

    var radio = argument0;

    Stuff.settings.selection.fill_type = radio.value;
    setting_set("Selection", "fill-type", Stuff.settings.selection.fill_type);


}
