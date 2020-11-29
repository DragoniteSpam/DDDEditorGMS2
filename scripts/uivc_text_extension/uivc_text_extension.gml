/// @param UIRadioOption
function uivc_text_extension(argument0) {

    var radio = argument0;

    Stuff.settings.config.text_extension = radio.value;
    setting_set("Config", "text-ext", Stuff.settings.config.text_extension);


}
