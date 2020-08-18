/// @param UICheckbox
function uivc_show_tooltips(argument0) {

	var checkbox = argument0;

	Stuff.setting_tooltip = checkbox.value;
	setting_set("Config", "tooltip", Stuff.setting_tooltip);


}
