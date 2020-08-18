/// @param UIRadioOption
function uivc_code_extension(argument0) {

	var radio = argument0;

	Stuff.setting_code_extension = radio.value;
	setting_set("Config", "code-ext", Stuff.setting_code_extension);


}
