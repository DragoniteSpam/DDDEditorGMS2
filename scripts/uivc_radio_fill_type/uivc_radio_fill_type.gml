/// @param UIRadioOption
function uivc_radio_fill_type(argument0) {

	var radio = argument0;

	Stuff.setting_selection_fill_type = radio.value;
	setting_set("Selection", "fill-type", Stuff.setting_selection_fill_type);


}
