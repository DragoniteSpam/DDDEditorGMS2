/// @param UIProgressBar
function uivc_focus_alpha(argument0) {

	var progress = argument0;

	Stuff.setting_focus_alpha = progress.value;
	setting_set("Config", "focus-alpha", Stuff.setting_focus_alpha);


}
