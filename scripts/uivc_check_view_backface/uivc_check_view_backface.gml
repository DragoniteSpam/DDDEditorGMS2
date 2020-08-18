/// @param UICheckbox
function uivc_check_view_backface(argument0) {

	var checkbox = argument0;

	Stuff.setting_view_backface = checkbox.value;
	setting_set("View", "backface", Stuff.setting_view_backface);


}
