/// @param UIInput
function uivc_bezier_precision(argument0) {

	var input = argument0;

	Stuff.setting_bezier_precision = real(input.value);
	setting_set("Config", "bezier", Stuff.setting_bezier_precision);


}
