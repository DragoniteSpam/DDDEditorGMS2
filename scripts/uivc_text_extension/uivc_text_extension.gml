/// @param UIRadioOption
function uivc_text_extension(argument0) {

    var radio = argument0;

    Settings.config.text_extension = radio.value;
    setting_set("Config", "text-ext", Settings.config.text_extension);


}
