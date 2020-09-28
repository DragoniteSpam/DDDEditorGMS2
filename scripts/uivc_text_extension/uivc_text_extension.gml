/// @param UIRadioOption
function uivc_text_extension(argument0) {

    var radio = argument0;

    Stuff.setting_text_extension = radio.value;
    setting_set("Config", "text-ext", Stuff.setting_text_extension);


}
